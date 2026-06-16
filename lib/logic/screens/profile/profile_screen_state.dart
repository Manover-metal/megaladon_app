part of 'profile_screen_cubit.dart';

enum ProfileScreenStatus { initial, loading, success, error, notAuth }

class ProfileScreenState extends Equatable {
  const ProfileScreenState(
      {this.status = ProfileScreenStatus.initial,
      this.user,
      this.isUpdatePrice = false,
      this.error});
  final ProfileScreenStatus status;
  final UserModel? user;
  final bool isUpdatePrice;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, user, isUpdatePrice, error];

  ProfileScreenState copyWith(
          {ProfileScreenStatus? status,
          UserModel? user,
          ExecutorModel? executor,
          StoreModel? store,
          bool? isUpdatePrice,
          ErrorModel? error}) =>
      ProfileScreenState(
          status: status ?? this.status,
          user: user ?? this.user,
          isUpdatePrice: isUpdatePrice ?? this.isUpdatePrice,
          error: error ?? this.error);
}
