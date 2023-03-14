import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/order_index_sort_enum.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class SortOrderBottomSheet extends StatefulWidget {
  @override
  State<SortOrderBottomSheet> createState() => _SortOrderBottomSheetState();
}

class _SortOrderBottomSheetState extends State<SortOrderBottomSheet> {

  late OrderIndexSort sortCurrent;
  late bool desc;

  _back() {
    OrderIndexRequestParams params = context.read<OrderScreenMainCubit>().state.params;
    context.read<OrderScreenMainCubit>().changeParams(params.copyWith(
        startRow: 0,
        sort: sortCurrent,
        desc: desc
    ));
    context.router.pop(true);
  }

  @override
  void initState() {
    OrderIndexRequestParams params = context.read<OrderScreenMainCubit>().state.params;
    sortCurrent = params.sort;
    desc = params.desc;
    super.initState();
  }

  _handleChange(OrderIndexSort sort) => () {
    if(sort.index == sortCurrent.index) {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TitleApp('Сортировать'),
            Divider(thickness: 1,height: 20,),
            BlocBuilder<OrderScreenMainCubit, OrderScreenMainState>(
                builder: (context, state) {
                  return Column(
                    children: OrderIndexSort.values.map((sort) {
                      return SortTile(
                        title: sort.toString(),
                        isActive: sortCurrent.index == sort.index,
                        desc: desc,
                        onTap: _handleChange(sort),
                      );
                    }).toList(),
                  );
                }
            ),
            SizedBox(height: 30,),
            ElevatedButtonApp(
                text: 'Применить',
                onPressed: _back
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}


class SortTile extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool desc;
  final VoidCallback onTap;

  const SortTile({super.key, required this.title, required this.isActive, required this.desc, required this.onTap});



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            if(isActive && desc) Icon(Icons.arrow_downward_rounded, color: Theme.of(context).colorScheme.primary)
            else if(isActive && !desc) Icon(Icons.arrow_upward_rounded, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 10,),
            Expanded(
              child: Text(title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isActive? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}