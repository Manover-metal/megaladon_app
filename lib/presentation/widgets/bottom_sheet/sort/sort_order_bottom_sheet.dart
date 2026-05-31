import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/order_index_sort_enum.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class SortOrderBottomSheet extends StatefulWidget {
  const SortOrderBottomSheet({super.key});

  Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      elevation: 100,
      builder: (_) => this);

  @override
  State<SortOrderBottomSheet> createState() => _SortOrderBottomSheetState();
}

class _SortOrderBottomSheetState extends State<SortOrderBottomSheet> {
  late OrderIndexSort sortCurrent;
  late bool desc;

  void _back() {
    var params = context.read<OrderScreenMainCubit>().state.params;
    context.read<OrderScreenMainCubit>().changeParams(
        params.copyWith(startRow: 0, sort: sortCurrent, desc: desc));
    context.router.pop(true);
  }

  @override
  void initState() {
    var params = context.read<OrderScreenMainCubit>().state.params;
    sortCurrent = params.sort;
    desc = params.desc;
    super.initState();
  }

  Null Function() _handleChange(OrderIndexSort sort) => () {
        if (sort.index == sortCurrent.index) {
          setState(() {
            desc = !desc;
          });
        } else {
          setState(() {
            sortCurrent = sort;
          });
        }
      };

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleApp(AppLocalizations.of(context)!.sort),
            const Divider(
              thickness: 1,
              height: 20,
            ),
            BlocBuilder<OrderScreenMainCubit, OrderScreenMainState>(
                builder: (context, state) => Column(
                      children: OrderIndexSort.values
                          .map((sort) => SortTile(
                                title: sort
                                    .localize(AppLocalizations.of(context)!),
                                isActive: sortCurrent.index == sort.index,
                                desc: desc,
                                onTap: _handleChange(sort),
                              ))
                          .toList(),
                    )),
            const SizedBox(
              height: 30,
            ),
            ElevatedButtonApp(
                text: AppLocalizations.of(context)!.apply, onPressed: _back),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      );
}

class SortTile extends StatelessWidget {
  const SortTile(
      {required this.title,
      required this.isActive,
      required this.desc,
      required this.onTap,
      super.key});
  final String title;
  final bool isActive;
  final bool desc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              if (isActive && desc)
                Icon(Icons.arrow_downward_rounded,
                    color: Theme.of(context).colorScheme.primary)
              else if (isActive && !desc)
                Icon(Icons.arrow_upward_rounded,
                    color: Theme.of(context).colorScheme.primary),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
      );
}
