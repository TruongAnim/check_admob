import 'package:flutter/material.dart';

class CountDownButton extends StatelessWidget {
  final int countDown;
  final String text;
  final Function? callback;
  const CountDownButton(
      {super.key, required this.countDown, required this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: countDown > 0
            ? null
            : () {
                callback?.call();
              },
        child: Text('$text ${countDown > 0 ? '- ${countDown}s' : ''}'));
  }
}
