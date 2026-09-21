import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/price_controller.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';

part 'price_form_state.dart';

class PriceFormCubit extends Cubit<PriceFormState> {
  PriceFormCubit(this.profileCubit, this.authBloc)
      : super(const PriceFormState()) {
    _checkUpdate();
    profileCubit.stream.listen((stateProfile) {
      _checkUpdate();
    });
  }

  final PriceController _repository = PriceController();
  final ProfileScreenCubit profileCubit;
  final AuthBloc authBloc;

  /// Идёт выбор и загрузка нового прайса.
  bool _adding = false;

  /// Прайсы, по которым сейчас летит запрос (вкл/выкл/удаление). Раньше
  /// запросы уходили «в фон» без всякой защиты, и двойное нажатие на
  /// переключатель или корзину слало два запроса.
  final Set<int> _busyIds = {};

  void _checkUpdate() {
    if (profileCubit.state.status == ProfileScreenStatus.success &&
        profileCubit.state.user?.store != null) {
      emit(PriceFormState(prices: profileCubit.state.user!.store!.prices));
    }
  }

  Future<void> addPrice() async {
    if (_adding) return;
    _adding = true;
    try {
      final result = await FilePicker.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf']);
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      final contentType = DioMediaType('application', 'pdf');
      final data = FormData.fromMap({
        'file': MultipartFile.fromBytes(file.bytes!,
            filename: file.name, contentType: contentType)
      });
      await _repository.addPrice(data);
      await profileCubit.updateData();
    } catch (error) {
      _emitError(error);
    } finally {
      _adding = false;
    }
  }

  Future<void> activate(int id) =>
      _run(id, () => _repository.activatePrice(id));

  Future<void> deactivate(int id) =>
      _run(id, () => _repository.deactivatePrice(id));

  Future<void> delete(int id) => _run(id, () => _repository.delete(id));

  /// Один запрос на прайс за раз; после ответа перечитываем профиль, чтобы
  /// список прайсов обновился.
  Future<void> _run(int id, Future<dynamic> Function() request) async {
    if (!_busyIds.add(id)) return;
    try {
      await request();
      await profileCubit.updateData();
    } catch (error) {
      _emitError(error);
    } finally {
      _busyIds.remove(id);
    }
  }

  void _emitError(Object error) {
    if (error is DioException) {
      emit(state.copyWith(error: ErrorModel.parseDio(error)));
    } else {
      emit(state.copyWith(error: ErrorModel.nothing));
    }
  }
}
