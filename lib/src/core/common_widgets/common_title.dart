import 'package:demo_project/src/core/constants/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonTitle extends StatelessWidget {
  final String title;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final TextAlign? alignment;
  final double? size;

  const CommonTitle({
    Key? key,
    required this.title,
    this.textColor = AppColor.text_main_color,
    this.fontWeight,
    this.textStyle,
    this.alignment,
    this.size = 26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: textColor, fontSize: size, fontWeight: FontWeight.w600),
      textAlign: alignment,
    );
  }
}
