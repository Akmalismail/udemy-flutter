import 'package:flutter/material.dart';

import './text_output.dart';

class TextControl extends StatefulWidget {
  const TextControl({Key? key}) : super(key: key);

  @override
  State<TextControl> createState() => _TextControlState();
}

class _TextControlState extends State<TextControl> {
  String _customText = 'Hello';

  void buttonHandler() {
    setState(() {
      _customText = _customText == 'Hello' ? 'World' : 'Hello';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(customText: _customText),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            child: const Text('Change text'),
            onPressed: buttonHandler,
          ),
        )
      ],
    );
  }
}
