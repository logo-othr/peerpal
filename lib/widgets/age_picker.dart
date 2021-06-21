import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AgePicker extends StatelessWidget {
  final Widget? hint;
  final List<String> items;
  final int? value;
  final ValueSetter<int?> onChanged;

  const AgePicker({
    Key? key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Container(
        color: Colors.transparent,
        height: 150,
        child: CupertinoPicker(
          itemExtent: 30,
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: onChanged,
          children: <Widget>[for (var i in items) Text(i.toString())],
        ),
      ),
    );
  }
}
