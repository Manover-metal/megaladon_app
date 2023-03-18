part of 'profile_screen_cubit.dart';

abstract class ProfileScreenState extends Equatable {}

class ProfileScreenInitial extends ProfileScreenState {
  ProfileScreenInitial();

  @override
  List<Object> get props => [];
}

class ProfileScreenLoader extends ProfileScreenState {
  ProfileScreenLoader();

  @override
  List<Object> get props => [];
}

class ProfileScreenUnauthorization extends ProfileScreenState {

  ProfileScreenUnauthorization();

  @override
  List<Object> get props => [];
}

class ProfileScreenError extends ProfileScreenState {
  final ErrorModel error;

  ProfileScreenError(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileScreenSuccess extends  ProfileScreenState {
  final UserModel user;
  final ExecutorModel? executor;
  final StoreModel? store;

  ProfileScreenSuccess({
    required this.user,
    this.executor,
    this.store
  });

  @override
  List<Object?> get props => [user, executor, store];

  ProfileScreenSuccess copyWith({
    UserModel? user,
    ExecutorModel? executor,
    StoreModel? store
  }) {
    return ProfileScreenSuccess(
        user: user ?? this.user,
        executor: executor ?? this.executor,
        store: store ?? this.store
    );
  }
}
