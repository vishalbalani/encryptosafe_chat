import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.onTap,
    required this.width,
    required this.height,
    this.color2,
    required this.color,
    required this.text,
    this.isLoading = false, // New isLoading parameter with default value false
  }) : super(key: key);

  final void Function()? onTap;
  final double width;
  final double height;
  final Color? color2;
  final Color color;
  final String text;
  final bool isLoading; // New isLoading parameter

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color2,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          border: Border.all(
            width: 1,
            color: color,
          ),
        ),
        child: Center(
          child: isLoading // Check if isLoading is true
              ? CircularProgressIndicator(
                  // Display CircularProgressIndicator if true
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                )
              : TextWidget(
                  text: text,
                  style: appstyle(18, color, FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
