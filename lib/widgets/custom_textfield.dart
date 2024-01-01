import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.keyboardType,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    required this.controller,
    this.onChanged,
    this.boxColor,
    this.fontStyle,
  }) : super(key: key);

  final TextInputType? keyboardType;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  final TextStyle? fontStyle;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final Color? boxColor;

  @override
  Widget build(BuildContext context) {
    final color = boxColor ?? Constants.white;
    final defaultHintStyle =
        hintStyle ?? appstyle(16, Colors.black38, FontWeight.w400);
    final defaultFontStyle =
        fontStyle ?? appstyle(18, Constants.darkBK, FontWeight.w500);
    return Container(
      width: Constants.width * 0.9,
      height: Constants.height * 0.08,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(Constants.radius),
        ),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        cursorHeight: 28,
        onChanged: onChanged,
        style: defaultFontStyle,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: defaultHintStyle,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          suffixIconColor: Constants.darkBK,
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Constants.red, width: 0.5),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.transparent, width: 0.5),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Constants.red, width: 0.5),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Constants.grayDark, width: 0.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Constants.darkBK, width: 0.5),
          ),
        ),
      ),
    );
  }
}
