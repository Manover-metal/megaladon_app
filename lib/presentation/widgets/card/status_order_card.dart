import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusOrderCard extends StatelessWidget {

  _handleClick() {

  }
  @override
  Widget build(BuildContext context) {
    return ActionChip(

      backgroundColor: Theme.of(context).colorScheme.background,
      shape: StadiumBorder(
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary
        )
      ),
      onPressed: _handleClick,
      padding: EdgeInsets.all(10),
      label: Text('Все'),
    );
  }

}