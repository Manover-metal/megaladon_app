import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: HeaderAppBar(isMenu: true, ),
                ),
                TileScreen(page: LoginRoute(),),
                TileScreen(page: VerifyRoute(),),
                TileScreen(page: ForgotPasswordRoute(),),
                TileScreen(page: ResetPasswordRoute(),),
                TileScreen(page: RegisterUserRoute(),),
                TileScreen(page: RegisterExecutorRoute(),),
                TileScreen(page: RegisterShopRoute(),),
                Divider(thickness: 1, height: 0,)

              ],
            ),
          ),
        ),
      ),
    );
  }

}

class TileScreen extends StatelessWidget {
  final PageRouteInfo page;

  const TileScreen({super.key, required this.page});
  
  _handleTap(BuildContext context) => () {
    context.router.push(page);
  };
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Text(page.routeName),
      ),
    );
  }
  
}