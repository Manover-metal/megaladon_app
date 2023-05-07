import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

class AuthGuard extends AutoRouteGuard {
  final BuildContext context;

  AuthGuard(this.context);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if(context.read<AuthBloc>().state is AuthLoginState) {
      resolver.next(true);
    } else {
      router.pop();
    }
  }
}

class NotAuthGuard extends AutoRouteGuard {
  final BuildContext context;

  NotAuthGuard(this.context);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if(context.read<AuthBloc>().state is! AuthLoginState) {
      resolver.next(true);
    } else {
      router.pop();
    }
  }
}