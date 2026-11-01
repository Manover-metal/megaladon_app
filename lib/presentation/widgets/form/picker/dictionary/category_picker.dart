import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/category_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/presentation/widgets/form/field_style.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/category_selection_screen.dart';

/// Какое дерево из [DictionaryCubit]: услуги (заказы, исполнители,
/// объявления-услуги) или объявления.
enum CategoryKind { service, advert }

List<CategoryModel> _categoriesOf(BuildContext context, CategoryKind kind) {
  final state = context.read<DictionaryCubit>().state;
  return kind == CategoryKind.service
      ? state.orderCategories
      : state.advertCategories;
}

class CategoryPickerController extends ValueNotifier<CategoryModel?> {
  CategoryPickerController({CategoryModel? category}) : super(category);

  void _changeCategory(CategoryModel? category) {
    value = category;
    notifyListeners();
  }
}

class CategoryPicker extends StatefulWidget {
  const CategoryPicker(
      {required this.label,
      required this.controller,
      required this.kind,
      super.key,
      this.errorText,
      this.withNull = false});
  final String label;
  final CategoryPickerController controller;
  final CategoryKind kind;
  final String? errorText;

  /// Для фильтров: есть «Все», и можно выбрать ветку целиком.
  final bool withNull;

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  // Как в CityPicker: не открываем экран выбора повторно, пока открыт прежний.
  bool _isOpening = false;

  Future<void> _handleClick() async {
    if (_isOpening) return;

    final categories = _categoriesOf(context, widget.kind);
    if (categories.isEmpty) return;

    _isOpening = true;
    try {
      final selected = widget.controller.value;
      final result = await Navigator.of(context).push<CategorySelectionResult>(
        MaterialPageRoute(
          builder: (_) => CategorySelectionScreen(
            title: widget.label,
            categories: categories,
            selected: [if (selected != null) selected],
            withNull: widget.withNull,
          ),
        ),
      );

      if (result != null) {
        widget.controller._changeCategory(
            result.selected.isEmpty ? null : result.selected.first);
      }
    } finally {
      if (mounted) _isOpening = false;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ValueListenableBuilder(
          builder: (context, category, child) => GestureDetector(
            onTap: _handleClick,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: FieldStyle.fillOf(context),
                    border: FieldStyle.borderOf(context,
                        hasError: widget.errorText != null),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(category?.name ??
                              (widget.withNull
                                  ? AppLocalizations.of(context)!.all
                                  : ''))),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
                if (widget.errorText != null) _ErrorText(widget.errorText!),
              ],
            ),
          ),
          valueListenable: widget.controller,
        ),
      );
}

class CategoryMultiPickerController extends ValueNotifier<List<CategoryModel>> {
  CategoryMultiPickerController({List<CategoryModel>? categories})
      : super(categories ?? const []);

  void _changeCategories(List<CategoryModel> categories) {
    value = categories;
  }

  void _remove(CategoryModel category) {
    value = value.where((c) => c.id != category.id).toList();
  }
}

/// Несколько конечных категорий: выбор на [CategorySelectionScreen] с
/// галочками, выбранные — чипами с крестиком. Подпись поля даёт обёртка
/// (AuthFieldGroup), [label] — заголовок экрана выбора.
class CategoryMultiPicker extends StatefulWidget {
  const CategoryMultiPicker(
      {required this.label,
      required this.controller,
      required this.kind,
      super.key,
      this.errorText});
  final String label;
  final CategoryMultiPickerController controller;
  final CategoryKind kind;
  final String? errorText;

  @override
  State<CategoryMultiPicker> createState() => _CategoryMultiPickerState();
}

class _CategoryMultiPickerState extends State<CategoryMultiPicker> {
  bool _isOpening = false;

  Future<void> _handleClick() async {
    if (_isOpening) return;

    final categories = _categoriesOf(context, widget.kind);
    if (categories.isEmpty) return;

    _isOpening = true;
    try {
      final result = await Navigator.of(context).push<CategorySelectionResult>(
        MaterialPageRoute(
          builder: (_) => CategorySelectionScreen(
            title: widget.label,
            categories: categories,
            selected: widget.controller.value,
            multiple: true,
          ),
        ),
      );

      if (result != null) widget.controller._changeCategories(result.selected);
    } finally {
      if (mounted) _isOpening = false;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, categories, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categories.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final c in categories)
                      InputChip(
                        label: Text(c.name),
                        onDeleted: () => widget.controller._remove(c),
                      ),
                  ],
                ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: _handleClick,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: FieldStyle.fillOf(context),
                    border: FieldStyle.borderOf(context,
                        hasError: widget.errorText != null),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                              AppLocalizations.of(context)!.choose_services)),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              if (widget.errorText != null) _ErrorText(widget.errorText!),
            ],
          ),
        ),
      );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4, left: 4),
        child: Text(
          text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.error, fontSize: 12),
        ),
      );
}
