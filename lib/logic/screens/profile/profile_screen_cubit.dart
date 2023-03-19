import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  final UserRepository _repository = UserRepository();
  final AuthBloc authBloc;
  
  ProfileScreenCubit(this.authBloc) : super(ProfileScreenState()) {
    authBloc.stream.listen((state) {
      if(state is AuthLoginState) {
        fetch(id: state.auth.user.value!.id);
      } else if(state is AuthInitial || state is AuthLogoutState) {
        emit(ProfileScreenState(status: ProfileScreenStatus.notAuth));
      }
    });
  }

  Future fetch({required int id}) async {
    emit(ProfileScreenState(status: ProfileScreenStatus.loading));
    return _fetch(id);
  }

  hoverChangePrice() {
    emit(state.copyWith(isUpdatePrice: !state.isUpdatePrice));
  }

  // addPrice(PlatformFile file) async {
  //   FormData data = FormData();
  //   data.files.add(MapEntry('file', await MultipartFile.fromFile(file.path!, filename: file.name)));
  //   await _repository.addPrice(data).then((value) {
  //     return _fetch(state.user!.id);
  //   }).catchError((error) {
  //     print(error.response.data);
  //   });
  // }

  // deleteByIndex(int index) async {
  //   if(state.store != null) {
  //     FileModel file = state.store!.prices![index];
  //     await _repository.deletePrice(file.id).then((value) {
  //       return _fetch(state.user!.id);
  //     }).catchError((error) {
  //       print(error.response.data);
  //     });
  //   }
  // }


  Future _fetch(int id) async {
    return await _repository.profile(id).then((value) {
      UserModel user = UserModel.fromJson(value['user']);
      ExecutorModel? executor = value['user']['executor'] != null? ExecutorModel.fromJson(value['user']['executor']): null;
      StoreModel? store = value['user']['store'] != null? StoreModel.fromJsonFull(value['user']['store']): null;
      emit(ProfileScreenState(
          status: ProfileScreenStatus.success,
          user: user,
          executor: executor,
          store: store
      ));
    }).catchError(( error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          emit(ProfileScreenState(status: ProfileScreenStatus.notAuth));
        } else {
          emit(ProfileScreenState(status: ProfileScreenStatus.error, error: ErrorModel.parseDio(error)));
        }
      } else {
        emit(ProfileScreenState(status: ProfileScreenStatus.error, error: ErrorModel.nothing));
      }
    });
  }
}
