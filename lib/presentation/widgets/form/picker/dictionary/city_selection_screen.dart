import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({
    required this.cities,
    super.key,
    this.selected,
  });

  final List<CityModel> cities;
  final CityModel? selected;

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  late List<CityModel> _filtered;
  CityModel? _selected;

  @override
  void initState() {
    super.initState();
    _filtered = widget.cities;
    _selected = widget.selected;
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
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final city = _filtered[index];
                final isSelected = city.id == _selected?.id;
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
                  onTap: () => setState(() => _selected = city),
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
                  onPressed: _selected == null
                      ? null
                      : () => Navigator.of(context).pop(_selected),
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
