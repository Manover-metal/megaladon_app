import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

enum ColorSchemeApp {
  primary(Color.fromRGBO(251, 191, 36, 1)),
  onPrimary(Colors.black),
  surface(Color.fromRGBO(251, 191, 36, 1)),
  onSurface(Color.fromRGBO(251, 191, 36, 1)),
  onBackgroud(Color.fromRGBO(30, 30, 30, 1)),
  background(Color.fromRGBO(30, 30, 30, 1)),
  bodyText(Colors.white),
  hiddenContainer(Color.fromRGBO(199, 196, 194, 1.0)),
  hidden(Color.fromRGBO(199, 196, 194, 1.0)),
  onHidden(Color.fromRGBO(251, 191, 36, 1)),
  error(Color.fromRGBO(239, 68, 68, 1)),
  onError(Colors.white),
  success(Color.fromRGBO(5, 150, 105, 1)),
  onSuccess(Colors.white),
  container(Color.fromRGBO(54, 54, 54, 1)),
  onContainer(Color.fromRGBO(54, 54, 54, 1));


  final Color color;

  const ColorSchemeApp(this.color);
}


TextTheme _textTheme = TextTheme(
    bodyLarge: TextStyle(
      fontSize: 27,
      color: ColorSchemeApp.primary.color,
      fontWeight: FontWeight.w600

    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: ColorSchemeApp.bodyText.color
    ),
    bodySmall: TextStyle(
      fontSize: 15,
      color: ColorSchemeApp.primary.color
    ),
    titleLarge: TextStyle(
      color: ColorSchemeApp.bodyText.color
    )
);

ThemeData themeDark =  FlexThemeData.dark(
  scheme: FlexScheme.mango,
  surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
  blendLevel: 7,
  appBarOpacity: 0.90,

  // tooltipsMatchBackground: true,
  onBackground: ColorSchemeApp.onBackgroud.color,
  background: ColorSchemeApp.background.color,
  textTheme: _textTheme,
  onPrimary: ColorSchemeApp.onPrimary.color,
  primary: ColorSchemeApp.primary.color,
  surface: ColorSchemeApp.surface.color,
  onSurface: ColorSchemeApp.onSurface.color,
  secondary: ColorSchemeApp.hidden.color,
  onSecondary: ColorSchemeApp.onHidden.color,
  secondaryContainer: ColorSchemeApp.hiddenContainer.color,
  scaffoldBackground: ColorSchemeApp.onBackgroud.color,
  onError: ColorSchemeApp.onError.color,
  error: ColorSchemeApp.error.color,
  tertiary: ColorSchemeApp.container.color,
  onTertiary: ColorSchemeApp.onContainer.color,



  subThemesData: FlexSubThemesData(
    defaultRadius: 10.0,
    inputDecoratorRadius: 10.0,
    inputDecoratorUnfocusedBorderIsColored: false,
    navigationBarHeight: 80.0,
    navigationRailIndicatorOpacity: 0.08,
    inputDecoratorSchemeColor: SchemeColor.secondaryContainer,

  ),

  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  // useMaterial3: true,
);
