import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Круг для людей, скруглённый квадрат для магазинов.
enum AvatarShape { circle, rounded }

/// Единый аватар приложения. Три состояния, одинаковые во всех списках и на
/// всех экранах: пока фото качается — shimmer, фотографии нет или она не
/// загрузилась — инициалы имени.
///
/// До этого виджета у каждого экрана был собственный приватный `_Avatar`, и
/// заглушка существовала в трёх вариантах — иконка человека, одна буква,
/// две буквы — с размером иконки, захардкоженным шестью разными числами.
class Avatar extends StatelessWidget {
  const Avatar({
    required this.name,
    required this.photoUrl,
    this.bytes,
    this.size = 40,
    this.shape = AvatarShape.circle,
    this.fallbackIcon,
    super.key,
  });

  /// Источник инициалов. Пустая строка допустима — тогда работает
  /// [fallbackIcon].
  final String name;

  final String? photoUrl;

  /// Локальные байты перекрывают [photoUrl]: в профиле только что выбранное
  /// фото надо показать до того, как оно доедет до сервера.
  final Uint8List? bytes;

  final double size;
  final AvatarShape shape;

  /// Для магазинов: у безымянного магазина инициалов нет, но есть логотип
  /// раздела. У людей остаётся null — там вместо иконки «?».
  final IconData? fallbackIcon;

  /// «Асхат Кенжебаев» → «АК». Имена приходят с сервера как есть, поэтому
  /// пустые части после split отбрасываем: двойные и хвостовые пробелы дали
  /// бы обращение к part[0] на пустой строке.
  String get _initials {
    final parts = name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase());

    return parts.join();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _clip(
      child: Container(
        width: size,
        height: size,
        color: scheme.secondaryContainer,
        alignment: Alignment.center,
        child: _content(scheme),
      ),
    );
  }

  Widget _clip({required Widget child}) => shape == AvatarShape.circle
      ? ClipOval(child: child)
      : ClipRRect(borderRadius: BorderRadius.circular(10), child: child);

  Widget _content(ColorScheme scheme) {
    final data = bytes;
    if (data != null) {
      return Image.memory(data, width: size, height: size, fit: BoxFit.cover);
    }

    final url = photoUrl;
    if (url == null || url.isEmpty) return _placeholder(scheme);

    return CachedNetworkImage(
      imageUrl: url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      // Ноль: фото из кэша иначе проявляется поверх shimmer'а и в списках
      // это читается как мигание.
      fadeInDuration: Duration.zero,
      progressIndicatorBuilder: (_, __, ___) => _ShimmerBox(size: size),
      errorWidget: (_, __, ___) => _placeholder(scheme),
    );
  }

  /// Цвет строго `onSecondaryContainer`, а не `secondary`: в тёмной теме
  /// `secondary` и `secondaryContainer` заданы одним и тем же #C7C4C2, и
  /// инициалы сливались с фоном круга — текст в дереве был, а на экране нет.
  Widget _placeholder(ColorScheme scheme) {
    final initials = _initials;

    if (initials.isEmpty && fallbackIcon != null) {
      return Icon(
        fallbackIcon,
        size: size * 0.5,
        color: scheme.onSecondaryContainer,
      );
    }

    return Text(
      initials.isEmpty ? '?' : initials,
      style: TextStyle(
        fontSize: size * 0.36,
        fontWeight: FontWeight.w700,
        color: scheme.onSecondaryContainer,
      ),
    );
  }
}

/// Цвет бегущего блика. Считается от самой заливки, а не от `surface`: в
/// тёмной теме `surface` почти чёрный (#1E1E1E), и блик по светло-серому
/// кругу читался дырой, а не загрузкой.
@visibleForTesting
Color shimmerHighlight(ColorScheme scheme) => Color.lerp(
      scheme.secondaryContainer,
      scheme.onSecondaryContainer,
      0.12,
    )!;

/// Бегущий блик по заливке. Отдельного пакета ради одного виджета в проекте
/// нет и не заводим.
class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({required this.size});
  final double size;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.secondaryContainer,
            shimmerHighlight(scheme),
            scheme.secondaryContainer,
          ],
          // Блик выезжает за левый край и уходит за правый, поэтому сдвиг
          // считается по диапазону [-1, 2], а не [0, 1].
          stops: [
            (_controller.value * 3 - 1).clamp(0.0, 1.0),
            (_controller.value * 3 - 0.5).clamp(0.0, 1.0),
            (_controller.value * 3).clamp(0.0, 1.0),
          ],
        ).createShader(bounds),
        child: child,
      ),
      child: Container(
        width: widget.size,
        height: widget.size,
        color: scheme.secondaryContainer,
      ),
    );
  }
}
