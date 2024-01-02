import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/height_spacer.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

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
            child: SvgPicture.asset(
              "assets/images/onboard.svg",
              width: 300,
            ),
          ),
          const HeightSpacer(height: 100),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                text: "EncryptoSafe",
                style: appstyle(30, Constants.white, FontWeight.w600),
              ),
              const HeightSpacer(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                ),
                child: Text(
                  "Privacy takes center stage".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: appstyle(
                    16,
                    Constants.grayLight,
                    FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
