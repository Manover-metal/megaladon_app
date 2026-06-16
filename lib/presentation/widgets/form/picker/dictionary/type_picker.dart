import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/company_type_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/type_selection_screen.dart';

class TypePickerController extends ValueNotifier<CompanyTypeModel?> {
  TypePickerController({CompanyTypeModel? type}) : super(type);

  void _changeType(CompanyTypeModel type) {
    value = type;
    notifyListeners();
  }
}

class TypePicker extends StatefulWidget {
  const TypePicker(
      {required this.label,
      required this.controller,
      super.key,
      this.icon,
      this.errorText});
  final String label;
  final TypePickerController controller;
  final Widget? icon;
  final String? errorText;

  @override
  State<TypePicker> createState() => _TypePickerState();
}

class _TypePickerState extends State<TypePicker> {
  Future<void> _handleClick() async {
    final types = context.read<DictionaryCubit>().state.companyTypes;

    if (types.isEmpty) return;

    final result = await Navigator.of(context).push<CompanyTypeModel>(
      MaterialPageRoute(
        builder: (_) => TypeSelectionScreen(
          types: types,
          selected: widget.controller.value,
        ),
      ),
    );

    if (result != null) {
      widget.controller._changeType(result);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ValueListenableBuilder(
          builder: (context, type, child) => GestureDetector(
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
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: widget.errorText != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(type?.name ?? '')),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
                if (widget.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      widget.errorText!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          valueListenable: widget.controller,
        ),
      );
}
