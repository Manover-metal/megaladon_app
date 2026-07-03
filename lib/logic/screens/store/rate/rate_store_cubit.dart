import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/store_repository.dart';

part 'rate_store_state.dart';

class RateStoreCubit extends Cubit<RateStoreState> {
  RateStoreCubit() : super(RateStoreInitial());

  final StoreRepository _repository = StoreRepository();

  Future<void> rate({
    required int storeId,
    required int value,
    required String comment,
    required List<PlatformFile> images,
  }) async {
    if (state is RateStoreLoading) return;

    emit(RateStoreLoading());

    final files = <MultipartFile>[];
    for (final file in images) {
      if (file.path != null) {
        files.add(
          await MultipartFile.fromFile(file.path!, filename: file.name),
        );
      }
    }

    final data = FormData.fromMap({
      'rate': value,
      if (comment.trim().isNotEmpty) 'comment': comment.trim(),
    });
    for (final file in files) {
      data.files.add(MapEntry('images[]', file));
    }

    await _repository.rate(storeId, data).then((_) {
      emit(RateStoreSuccess());
    }).catchError((Object error) {
      if (error is DioException) {
        emit(RateStoreError(ErrorModel.parseDio(error)));
      } else {
        emit(RateStoreError(ErrorModel.nothing));
      }
    });
  }
}
