# megaladon


## Getting Started

#### Import package pub

```
flutter pub get
```

#### Next step it`s generate files for package auto_route and isar
```
flutter pub run build_runner build
```

#### You need change this line:
```dart
import 'package:flutter/material.dart';
```
on
```dart
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
```
#### In next files:
```
/Users/<usename>/.pub-cache/hosted/pub.dev/modal_bottom_sheet-2.1.2/lib/src/material_with_modal_page_route.dart
/Users/<usename>/.pub-cache/hosted/pub.dev/modal_bottom_sheet-2.1.2/lib/src/bottom_sheets/bar_bottom_sheet.dart
/Users/<usename>/.pub-cache/hosted/pub.dev/modal_bottom_sheet-2.1.2/lib/src/bottom_sheets/material_bottom_sheet.dart
```
### Just package modal_bottom_sheet not working in version 2.1.2. Maybe in next version fix problem with 'material.dart' 