import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';
import 'package:megaladon/data/repositories/order_repository.dart';
import 'package:megaladon/data/repositories/user_repository.dart';

part 'user_profile_state.dart';

/// Публичная страница пользователя: карточка и три вкладки со списками.
/// Вкладки грузятся лениво — при первом открытии, поэтому переключение
/// туда-обратно не дёргает сеть повторно.
class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(
    this.userId, {
    UserRepository? userRepository,
    AdvertRepository? advertRepository,
    OrderRepository? orderRepository,
  })  : _userRepository = userRepository ?? UserRepository(),
        _advertRepository = advertRepository ?? AdvertRepository(),
        _orderRepository = orderRepository ?? OrderRepository(),
        super(const UserProfileState());

  final int userId;
  final UserRepository _userRepository;
  final AdvertRepository _advertRepository;
  final OrderRepository _orderRepository;

  Future<void> loadProfile() async {
    emit(state.copyWith(profileStatus: LoadStatus.loading));
    try {
      final user = await _userRepository.publicProfile(userId);
      emit(state.copyWith(profileStatus: LoadStatus.success, user: user));
    } catch (_) {
      // Сюда попадает и 404 удалённого аккаунта: экран показывает
      // «Пользователь не найден» вместо контента.
      emit(state.copyWith(profileStatus: LoadStatus.error));
    }
  }

  Future<void> loadTab(UserProfileTab tab) async {
    final current = state.statusOf(tab);
    if (current == LoadStatus.loading || current == LoadStatus.success) return;

    emit(state.copyWith(tabStatus: _withStatus(tab, LoadStatus.loading)));

    try {
      switch (tab) {
        case UserProfileTab.adverts:
          final list = await _advertRepository.index(
              AdvertIndexRequestParams(userId: userId, type: AdvertType.advert),
              AdvertType.advert);
          emit(state.copyWith(
              adverts: list, tabStatus: _withStatus(tab, LoadStatus.success)));
          break;
        case UserProfileTab.services:
          final list = await _advertRepository.index(
              AdvertIndexRequestParams(
                  userId: userId, type: AdvertType.service),
              AdvertType.service);
          emit(state.copyWith(
              services: list, tabStatus: _withStatus(tab, LoadStatus.success)));
          break;
        case UserProfileTab.orders:
          final list = await _orderRepository
              .index(OrderIndexRequestParams(userId: userId));
          emit(state.copyWith(
              orders: list, tabStatus: _withStatus(tab, LoadStatus.success)));
          break;
      }
    } catch (_) {
      emit(state.copyWith(tabStatus: _withStatus(tab, LoadStatus.error)));
    }
  }

  /// Повторная загрузка вкладки после ошибки — сбрасывает статус,
  /// иначе loadTab выйдет по guard'у.
  Future<void> retryTab(UserProfileTab tab) async {
    emit(state.copyWith(tabStatus: _withStatus(tab, LoadStatus.initial)));
    await loadTab(tab);
  }

  Map<UserProfileTab, LoadStatus> _withStatus(
          UserProfileTab tab, LoadStatus status) =>
      {...state.tabStatus, tab: status};
}
