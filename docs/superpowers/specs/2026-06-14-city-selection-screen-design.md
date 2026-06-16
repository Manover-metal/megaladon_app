# City Selection Screen — Design

**Date:** 2026-06-14

## Goal

Replace the Cupertino wheel-picker modal in `CityPicker` with a dedicated full screen
that has an AppBar (back button, title "Выбор города") and a local search field.

## Scope

- Extract the city-selection UI into its own widget/screen.
- Convert the modal popup into a pushed `Scaffold` screen.
- Add a `TextField` that filters the city list locally (case-insensitive, by `name`).

No changes to the public API of `CityPicker` / `CityPickerController`; consuming
screens are unaffected.

## Components

### 1. `CitySelectionScreen` (new)
File: `lib/presentation/widgets/form/picker/dictionary/city_selection_screen.dart`

- `StatefulWidget` with `final List<CityModel> cities;` and `final CityModel? selected;`.
- Returns the chosen `CityModel` via `Navigator.pop(context, city)`; returns nothing on back.
- Layout:
  - `Scaffold` + `AppBar(title: city_selection_title)`, automatic back leading.
  - Search `TextFieldApp` (with `hintText: search`) at the top — filters `_filtered` on change.
  - `ListView` of `_filtered` cities; tapping highlights selection (background tint +
    trailing `Icons.check`).
  - Bottom "Выбрать" button (`select` key) → `Navigator.pop(context, _selected)`,
    disabled when nothing selected.
- State: `TextEditingController _searchController`, `List<CityModel> _filtered`,
  `CityModel? _selected` (initialized from `selected`).

### 2. `CityPicker._handleClick` (modified)
- Read `cities` from `DictionaryCubit`.
- `Navigator.push` `CitySelectionScreen(cities, selected: controller.value)`.
- On non-null result, call `controller._changeCity(result)`.
- Remove all debug `print(...)` statements (in `_handleClick`, `initState`, and
  `CityPickerController._changeCity`).

### 3. `TextFieldApp` (modified)
- Add optional `ValueChanged<String>? onChanged` and `String? hintText` params
  (backward compatible) so the search field reuses existing styling.

### 4. Localization (`app_ru.arb`, `app_kk.arb`, `app_en.arb`)
- `city_selection_title` → "Выбор города" / "Қала таңдау" / "Select a city"
- `search` → "Поиск" / "Іздеу" / "Search"
- Reuse existing `select` key for the confirm button.
- Regenerate l10n.

## Verification
- `flutter analyze` clean.
- Manual: open city picker → screen pushes with AppBar/back; typing filters list;
  tap highlights; "Выбрать" returns city to the field.
