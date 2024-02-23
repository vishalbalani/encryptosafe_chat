import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showAlertDialog({
  required BuildContext context,
  required String message,
  String? btnText,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          message,
          style: appstyle(18, Constants.white, FontWeight.w600),
        ),
        contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: TextWidget(
              text: btnText ?? "OK",
              style: appstyle(18, Constants.grayLight, FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );
}
