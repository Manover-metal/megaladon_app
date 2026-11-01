import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/category_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

/// Result of [CategorySelectionScreen]. A `null` screen result means the user
/// cancelled (back); an empty [selected] means the user explicitly chose
/// "all" (only possible when `withNull` is true).
class CategorySelectionResult {
  const CategorySelectionResult(this.selected);
  final List<CategoryModel> selected;
}

/// Выбор из дерева категорий по образцу [CitySelectionScreen]: сначала корни,
/// нажатие на категорию с вложенными открывает её тем же экраном. Выбрать
/// можно только конечную; с [withNull] (фильтры) — ещё «Все» и ветку целиком.
/// Выбор общий для всех уровней, «Выбрать» закрывает весь стек.
class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({
    required this.title,
    required this.categories,
    super.key,
    this.selected = const [],
    this.multiple = false,
    this.withNull = false,
  });

  final String title;
  final List<CategoryModel> categories;
  final List<CategoryModel> selected;
  final bool multiple;
  final bool withNull;

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  late final _Selection _selection = _Selection(
    widget.selected,
    multiple: widget.multiple,
    cleared: widget.withNull && widget.selected.isEmpty,
  );

  @override
  void dispose() {
    _selection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Level(
        title: widget.title,
        categories: widget.categories,
        path: const [],
        selection: _selection,
        withNull: widget.withNull,
      );
}

class _Selection extends ChangeNotifier {
  _Selection(List<CategoryModel> initial,
      {required this.multiple, required this.cleared})
      : items = [...initial];

  final bool multiple;
  final List<CategoryModel> items;

  /// Явно выбрано «Все».
  bool cleared;

  bool get canSubmit => cleared || items.isNotEmpty;

  bool has(CategoryModel c) => items.any((e) => e.id == c.id);

  void toggle(CategoryModel c) {
    cleared = false;
    if (has(c)) {
      if (multiple) items.removeWhere((e) => e.id == c.id);
    } else {
      if (!multiple) items.clear();
      items.add(c);
    }
    notifyListeners();
  }

  void clear() {
    cleared = true;
    items.clear();
    notifyListeners();
  }

  /// Сколько выбрано внутри ветки — счётчик у родителя.
  int countIn(CategoryModel c) => c.children
      .fold(0, (n, child) => n + (has(child) ? 1 : 0) + countIn(child));
}

class _Found {
  const _Found(this.category, this.path);
  final CategoryModel category;
  final List<String> path;
}

class _Level extends StatefulWidget {
  const _Level({
    required this.title,
    required this.categories,
    required this.path,
    required this.selection,
    required this.withNull,
    this.parent,
  });

  final String title;
  final List<CategoryModel> categories;

  /// Названия родителей от корня до этого уровня.
  final List<String> path;
  final _Selection selection;
  final bool withNull;
  final CategoryModel? parent;

  @override
  State<_Level> createState() => _LevelState();
}

class _LevelState extends State<_Level> {
  String _query = '';

  /// Поиск — по всей ветке уровня; ветку целиком ищем только в фильтрах.
  Iterable<_Found> _flatten(
      List<CategoryModel> categories, List<String> path) sync* {
    for (final c in categories) {
      if (c.isLeaf || widget.withNull) yield _Found(c, path);
      yield* _flatten(c.children, [...path, c.name]);
    }
  }

  Future<void> _open(CategoryModel c) async {
    final result = await Navigator.of(context).push<CategorySelectionResult>(
      MaterialPageRoute(
        builder: (_) => _Level(
          title: c.name,
          categories: c.children,
          path: [...widget.path, c.name],
          selection: widget.selection,
          withNull: widget.withNull,
          parent: c,
        ),
      ),
    );
    // Выбор подтверждён на вложенном уровне — закрываем и этот.
    if (result != null && mounted) Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = _query.trim().toLowerCase();

    return Scaffold(
      appBar: HeaderAppBar(title: widget.title),
      body: Column(
        children: [
          if (widget.path.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.path.join(' › '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldApp(
              hintText: l10n.search,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.selection,
              builder: (context, _) {
                final selection = widget.selection;
                final parent = widget.parent;
                final tiles = <Widget>[
                  if (query.isEmpty && widget.withNull && parent == null)
                    _tile(l10n.all,
                        selected: selection.cleared, onTap: selection.clear),
                  if (query.isEmpty && widget.withNull && parent != null)
                    _tile(l10n.category_all_in(parent.name),
                        selected: selection.has(parent),
                        onTap: () => selection.toggle(parent)),
                  if (query.isEmpty)
                    for (final c in widget.categories)
                      c.isLeaf
                          ? _tile(c.name,
                              selected: selection.has(c),
                              onTap: () => selection.toggle(c))
                          : _branch(c,
                              selection.countIn(c) + (selection.has(c) ? 1 : 0))
                  else
                    for (final found in _flatten(widget.categories, const [])
                        .where((f) =>
                            f.category.name.toLowerCase().contains(query)))
                      _tile(found.category.name,
                          subtitle: found.path.join(' › '),
                          selected: selection.has(found.category),
                          onTap: () => selection.toggle(found.category)),
                ];
                return tiles.isEmpty
                    ? Center(child: Text(l10n.category_nothing_found))
                    : ListView(children: tiles);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ListenableBuilder(
                  listenable: widget.selection,
                  builder: (context, _) {
                    final selection = widget.selection;
                    return ElevatedButton(
                      onPressed: selection.canSubmit
                          ? () => Navigator.of(context).pop(
                              CategorySelectionResult(List.of(selection.items)))
                          : null,
                      child: Text(
                          selection.multiple && selection.items.isNotEmpty
                              ? l10n.select_count(selection.items.length)
                              : l10n.select),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(String title,
      {required bool selected, required VoidCallback onTap, String? subtitle}) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(title, style: theme.textTheme.bodyMedium),
      subtitle: subtitle == null || subtitle.isEmpty
          ? null
          : Text(subtitle, style: theme.textTheme.bodySmall),
      selected: selected,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      trailing: widget.selection.multiple
          ? Checkbox(value: selected, onChanged: (_) => onTap())
          : selected
              ? Icon(Icons.check, color: theme.colorScheme.primary)
              : null,
      onTap: onTap,
    );
  }

  /// Категория с вложенными: выбрать нельзя, только открыть.
  Widget _branch(CategoryModel c, int selectedInside) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(c.name, style: theme.textTheme.bodyMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedInside > 0)
            Text(
              selectedInside.toString(),
              style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600),
            ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => _open(c),
    );
  }
}
