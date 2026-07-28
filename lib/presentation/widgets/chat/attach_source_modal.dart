import 'dart:io';

import 'package:flutter/material.dart';
import 'package:megaladon/core/image/image_service.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

/// Показывает нижнюю модалку выбора источника вложения (файл / фото / камера).
///
/// Сама выполняет выбор через [ImageService] и возвращает [File] выбранного
/// вложения, либо null, если пользователь закрыл модалку или отменил выбор.
Future<File?> showAttachSourceModal(BuildContext context) =>
    showModalBottomSheet<File>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (_) => const _AttachSourceModal(),
    );

class _AttachSourceModal extends StatelessWidget {
  const _AttachSourceModal();

  /// Выполняет [pick] и закрывает модалку с результатом. Результат отдаём
  /// даже если он null — при null внешний код просто ничего не отправит.
  Future<void> _pickAndClose(
    BuildContext context,
    Future<File?> Function() pick,
  ) async {
    final file = await pick();
    if (context.mounted) Navigator.of(context).pop(file);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme.primary;
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.insert_drive_file, color: color),
            title: Text(l10n.file),
            onTap: () => _pickAndClose(context, ImageService.getDocument),
          ),
          ListTile(
            leading: Icon(Icons.photo, color: color),
            title: Text(l10n.photo),
            onTap: () => _pickAndClose(context, ImageService.getGalleryPhoto),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt, color: color),
            title: Text(l10n.camera),
            onTap: () => _pickAndClose(context, ImageService.getCameraPhoto),
          ),
        ],
      ),
    );
  }
}
