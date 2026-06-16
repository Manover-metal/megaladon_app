import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// Amber accent brand color slightly darkened for light background contrast
const _primary = Color(0xFFD97706);
const _onPrimary = Colors.white;
const _background = Color(0xFFF8FAFC);
const _onBackground = Color(0xFF1E293B);
const _surface = Color(0xFFF1F5F9);
const _onSurface = Color(0xFFD97706);
const _secondary = Color(0xFF64748B);
const _onSecondary = Color(0xFFD97706);
const _secondaryContainer = Color(0xFFCBD5E1);
const _error = Color(0xFFEF4444);
const _onError = Colors.white;
// tertiary is used as input field background
const _tertiary = Color(0xFFFFFFFF);
const _onTertiary = Color(0xFFE2E8F0);

TextTheme _textThemeLight = const TextTheme(
  bodyLarge:
      TextStyle(fontSize: 25, color: _primary, fontWeight: FontWeight.w600),
  bodyMedium: TextStyle(fontSize: 18, color: _onBackground),
  bodySmall: TextStyle(fontSize: 15, color: _primary),
  titleLarge: TextStyle(color: _onBackground),
);

ThemeData themeLight = FlexThemeData.light(
  scheme: FlexScheme.mango,
  surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
  blendLevel: 4,
  appBarOpacity: 0.95,
  primary: _primary,
  onPrimary: _onPrimary,
  surface: _surface,
  onSurface: _onSurface,
  secondary: _secondary,
  onSecondary: _onSecondary,
  secondaryContainer: _secondaryContainer,
  scaffoldBackground: _background,
  error: _error,
  onError: _onError,
  tertiary: _tertiary,
  onTertiary: _onTertiary,
  textTheme: _textThemeLight,
  subThemesData: const FlexSubThemesData(
    defaultRadius: 10,
    inputDecoratorRadius: 10,
    inputDecoratorUnfocusedBorderIsColored: false,
    navigationBarHeight: 80,
    navigationRailIndicatorOpacity: 0.08,
    inputDecoratorSchemeColor: SchemeColor.secondaryContainer,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
);
