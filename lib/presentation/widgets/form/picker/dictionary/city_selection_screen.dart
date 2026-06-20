import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

/// Result of [CitySelectionScreen]. A `null` screen result means the user
/// cancelled (back), while a non-null result with `city == null` means the
/// user explicitly chose "no city" (only possible when `withNull` is true).
class CitySelectionResult {
  const CitySelectionResult(this.city);
  final CityModel? city;
}

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({
    required this.cities,
    super.key,
    this.selected,
    this.withNull = false,
  });

  final List<CityModel> cities;
  final CityModel? selected;

  /// When true, an "all / not selected" option is shown that clears the value.
  final bool withNull;

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  late List<CityModel> _filtered;
  CityModel? _selected;
  // True when the user explicitly picked the "all" option (clear).
  bool _clear = false;

  @override
  void initState() {
    super.initState();
    _filtered = widget.cities;
    _selected = widget.selected;
    _clear = widget.withNull && widget.selected == null;
  }

  void _onSearch(String query) {
    final normalized = query.trim().toLowerCase();
    setState(() {
      _filtered = normalized.isEmpty
          ? widget.cities
          : widget.cities
              .where((c) => c.name.toLowerCase().contains(normalized))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HeaderAppBar(title: l10n.city_selection_title),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldApp(
              hintText: l10n.search,
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length + (widget.withNull ? 1 : 0),
              itemBuilder: (context, index) {
                if (widget.withNull && index == 0) {
                  return ListTile(
                    title: Text(
                      l10n.all,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    selected: _clear,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    trailing: _clear
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => setState(() {
                      _clear = true;
                      _selected = null;
                    }),
                  );
                }
                final city = _filtered[index - (widget.withNull ? 1 : 0)];
                final isSelected = !_clear && city.id == _selected?.id;
                return ListTile(
                  title: Text(
                    city.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  selected: isSelected,
                  selectedTileColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () => setState(() {
                    _clear = false;
                    _selected = city;
                  }),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_selected == null && !_clear)
                      ? null
                      : () => Navigator.of(context)
                          .pop(CitySelectionResult(_selected)),
                  child: Text(l10n.select),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
