import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String customText;

  const CustomText({Key? key, required this.customText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(customText);
  }
}
