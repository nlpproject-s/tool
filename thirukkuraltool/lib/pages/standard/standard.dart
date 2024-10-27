import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Standart extends StatelessWidget {
  final List<int> list;

  const Standart({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item ${list[index]}'),
        );
      },
    );
  }
}
