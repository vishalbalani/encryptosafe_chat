import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class GPTPage extends StatelessWidget {
  const GPTPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(
        text: "COMMING SOON",
        style: appstyle(30, Constants.white, FontWeight.w600),
      ),
    );
  }
}
