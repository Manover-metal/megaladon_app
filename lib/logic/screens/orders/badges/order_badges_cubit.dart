import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/order_badges_model.dart';
import 'package:megaladon/data/repositories/order_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'order_badges_state.dart';

/// Счётчики изменившихся заказов для бейджей в меню и на вкладках «моих
/// заказов». Живёт отдельно от экранных кубитов, потому что бейдж нужен и
/// тогда, когда ни один из списков заказов не открыт.
///
/// Опрашивает `GET /order/badges` — два числа вместо полных списков: заказы
/// меняются редко, гонять ради бейджа выдачу с описаниями незачем.
class OrderBadgesCubit extends Cubit<OrderBadgesState>
    with WidgetsBindingObserver {
  OrderBadgesCubit(this.authBloc) : super(const OrderBadgesState()) {
    WidgetsBinding.instance.addObserver(this);
    _listenAuth(authBloc.state);
    _authSub = authBloc.stream.listen(_listenAuth);
  }

  final OrderRepository _repository = OrderRepository();
  final AuthBloc authBloc;

  static const Duration _pollInterval = Duration(minutes: 2);

  StreamSubscription<AuthState>? _authSub;
  Timer? _timer;
  bool _inFlight = false;

  void _listenAuth(AuthState state) {
    if (state is AuthLoginState) {
      fetch();
      _restartTimer();
    } else if (state is AuthInitial || state is AuthLogoutState) {
      _stop();
      emit(const OrderBadgesState());
    }
  }

  /// Перечитывает счётчики. Зовётся по таймеру, при возврате из фона и после
  /// того, как пользователь закрыл карточку заказа: открытие карточки гасит
  /// отметку на бэкенде, и бейдж должен погаснуть сразу, а не через две минуты.
  Future<void> fetch() async {
    if (_inFlight || authBloc.state is! AuthLoginState) return;
    _inFlight = true;
    try {
      final badges = await _repository.badges();
      emit(OrderBadgesState(badges: badges));
    } catch (error) {
      // Бейдж — вспомогательная информация: молча оставляем прежние числа.
      // ignore: avoid_print
      print('order badges error: $error');
    } finally {
      _inFlight = false;
    }
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = null;
    if (authBloc.state is! AuthLoginState) return;
    _timer = Timer.periodic(_pollInterval, (_) => fetch());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetch();
      _restartTimer();
    } else {
      _stop();
    }
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    _stop();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
