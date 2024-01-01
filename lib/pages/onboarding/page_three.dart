import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/pages/auth/login_page.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/custom_button.dart';
import 'package:encryptosafe/widgets/height_spacer.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.height,
      width: Constants.width,
      color: Constants.darkBK,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Image.asset("assets/images/todo.png"),
          ),
          const HeightSpacer(height: 100),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                text: "ToDo with Riverpod",
                style: appstyle(30, Constants.white, FontWeight.w600),
              ),
              const HeightSpacer(height: 50),
              CustomButton(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  width: Constants.width * 0.9,
                  height: Constants.height * 0.06,
                  color: Constants.white,
                  text: "Login with a phone number")
            ],
          ),
        ],
      ),
    );
  }
}
