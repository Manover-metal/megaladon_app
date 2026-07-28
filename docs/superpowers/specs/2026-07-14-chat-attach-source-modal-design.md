# Chat attach-source modal

## Problem

Tapping the 📎 button in the chat input (`details_chat_screen.dart`) currently
calls `ImageService.getFile()` directly, which only lets the user pick a
document via `file_picker`. There is no way to attach a gallery photo or take a
photo with the camera.

## Goal

Tapping 📎 opens a modal bottom sheet first. The sheet offers three sources —
**Файл**, **Фото**, **Камера** — does the picking internally, and returns a
`dart:io File` (or `null` if the user cancels). The screen then sends that file
through the existing chat-send path.

## Design

### Flow

```
📎 tap → showAttachSourceModal(context): Future<File?>
       → user taps a row (Файл / Фото / Камера)
       → sheet runs the matching picker, wraps result as File, Navigator.pop(file)
       → _attachFile: File → bytes → PlatformFile → _cubit.sendFile(...)
```

`ChatCubit.sendFile(int, PlatformFile)` and the backend upload path are
**unchanged**. The screen bridges `File → PlatformFile` so the existing
bytes-based multipart send keeps working.

### New widget — `lib/presentation/widgets/chat/attach_source_modal.dart`

- `Future<File?> showAttachSourceModal(BuildContext context)` — calls
  `showModalBottomSheet` (matching the app's existing usage:
  `useRootNavigator: true`, `useSafeArea: true`).
- Sheet body: three `ListTile`s with leading icons
  (`Icons.insert_drive_file`, `Icons.photo`, `Icons.camera_alt`) and localized
  titles. Each `onTap` awaits its picker, then `Navigator.pop(file)`.
- Cancel / tap-outside → sheet returns `null`.

### Picking per source — extend `ImageService`

- **Файл**: existing `getFile()` (`FilePicker.pickFiles`, custom extensions
  `pdf, doc, docx, jpg, jpeg, png`) → `File(result.files.first.path!)`.
- **Фото**: new `getGalleryPhoto()` → `ImagePicker().pickImage(source: gallery)`
  → `File(xfile.path)`.
- **Камера**: new `getCameraPhoto()` → `ImagePicker().pickImage(source: camera)`
  → `File(xfile.path)`.

All three return `Future<File?>`. Picker calls live in `ImageService`, not the
widget.

### `_attachFile` in `details_chat_screen.dart`

```dart
Future<void> _attachFile() async {
  final file = await showAttachSourceModal(context);
  if (file == null) return;
  final bytes = await file.readAsBytes();
  _cubit.sendFile(widget.chat.id, PlatformFile(
    name: file.path.split('/').last,
    size: bytes.length,
    bytes: bytes,
    path: file.path,
  ));
  _scrollToBottom();
}
```

## Other changes

- `pubspec.yaml`: add `image_picker: ^0.8.9` (Dart 2.19-compatible; 1.x needs
  Dart 3).
- Localization: add `attach_file` (sheet title), `file`, `photo`, `camera` to
  `app_ru.arb`, `app_en.arb`, `app_kk.arb`; regenerate via build.
- iOS `Info.plist`: **no change** — `NSCameraUsageDescription` and
  `NSPhotoLibraryUsageDescription` already present.

## Out of scope

- Multi-file selection.
- Web support (project is Android/iOS only — no `web/` folder).
- Changing the `PlatformFile`-based `sendFile` signature or backend.

## Testing

- Manual: 📎 → each of the three rows sends the expected attachment; cancel
  sends nothing.
- `flutter analyze` clean on changed files.
