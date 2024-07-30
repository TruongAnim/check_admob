import 'package:flutter/material.dart';

class HorizontalRadio extends StatelessWidget {
  final List<String> titles;
  final List<String> values;
  final String groupValue;
  final Function? callback;
  const HorizontalRadio(
      {super.key,
      required this.titles,
      required this.values,
      required this.groupValue,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(titles.length, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: values[index],
              groupValue: groupValue,
              onChanged: (v) {
                callback?.call(v);
              },
            ),
            Text(titles[index]),
          ],
        );
      }),
    );
  }
}
