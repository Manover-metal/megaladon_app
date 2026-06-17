import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  const CustomSnackBar({
    required super.content,
    super.key,
    super.backgroundColor,
    this.foregroundColor,
  });

  factory CustomSnackBar.success(Widget content) => CustomSnackBar.styled(
        content: content,
        backgroundColor: const Color.fromRGBO(72, 187, 120, 1),
        foregroundColor: Colors.white,
      );

  factory CustomSnackBar.error(Widget content) => CustomSnackBar.styled(
        content: content,
        backgroundColor: const Color.fromRGBO(229, 62, 62, 1),
        foregroundColor: Colors.white,
      );

  factory CustomSnackBar.primary(Widget content) => CustomSnackBar.styled(
        content: content,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        foregroundColor: Colors.white,
      );

  factory CustomSnackBar.errorInfo(Widget content) => CustomSnackBar.styled(
        content: content,
        backgroundColor: const Color.fromRGBO(255, 237, 240, 1),
        foregroundColor: const Color.fromRGBO(255, 37, 73, 1),
      );

  factory CustomSnackBar.info(Widget content) => CustomSnackBar.styled(
        content: content,
        backgroundColor: const Color.fromRGBO(141, 221, 255, 1),
        foregroundColor: Colors.white,
      );

  factory CustomSnackBar.warning(Widget content) => CustomSnackBar.styled(
        content: content,
        backgroundColor: const Color.fromRGBO(229, 190, 62, 1),
        foregroundColor: Colors.white,
      );

  factory CustomSnackBar.styled({
    required Widget content,
    Color? backgroundColor,
    Color? foregroundColor,
  }) =>
      CustomSnackBar(
        content: IconTheme(
          data: IconThemeData(color: foregroundColor),
          child: DefaultTextStyle(
            style: TextStyle(
              color: foregroundColor,
              fontSize: 15,
              fontFamily: 'SemiBold',
              letterSpacing: 0,
              height: 1.2,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: content,
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      icon: Icon(
                        Icons.close,
                        color: foregroundColor ?? Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      );

  final Color? foregroundColor;

  @override
  EdgeInsetsGeometry? get margin => const EdgeInsets.all(16);

  @override
  SnackBarBehavior? get behavior => SnackBarBehavior.floating;

  @override
  EdgeInsetsGeometry? get padding => EdgeInsets.zero;

  @override
  ShapeBorder? get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: foregroundColor ?? Colors.white, width: 1),
      );

  void view(BuildContext context) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    try {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          this,
          snackBarAnimationStyle: const AnimationStyle(
            duration: Duration(milliseconds: 500), // Show animation duration
            reverseDuration:
                Duration(milliseconds: 300), // Hide animation duration
          ),
        );
    } catch (_) {
      // Игнорируем редкую гонку, когда Scaffold демонтируется во время
      // перехода между экранами (ScaffoldMessenger._updateScaffolds).
    }
  }
}
