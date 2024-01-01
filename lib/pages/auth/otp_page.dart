import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/pages/auth/login_page.dart';
import 'package:encryptosafe/provider/auth_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/height_spacer.dart';
import 'package:encryptosafe/widgets/pinput_theme.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends ConsumerWidget {
  const OtpPage({
    super.key,
    required this.smsCodeId,
    required this.phone,
  });

  final String smsCodeId;
  final String phone;

  void verifyOtpCode(BuildContext context, WidgetRef ref, String smsCode) {
    ref.read(AuthProvider).verifyOtp(
          phone: phone,
          context: context,
          verificationId: smsCodeId,
          smsCodeId: smsCodeId,
          smsCode: smsCode,
          mounted: true,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeightSpacer(height: Constants.height * 0.12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Image.asset(
                  "assets/images/todo.png",
                  width: Constants.width * 0.5,
                ),
              ),
              const HeightSpacer(
                height: 26,
              ),
              TextWidget(
                text: "Enter your otp code",
                style: appstyle(
                  18,
                  Constants.white,
                  FontWeight.bold,
                ),
              ),
              const HeightSpacer(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  onCompleted: (value) {
                    if (value.length == 6) {
                      return verifyOtpCode(context, ref, value);
                    }
                  },
                  onSubmitted: (value) {
                    if (value.length == 6) {
                      return verifyOtpCode(context, ref, value);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      child: TextWidget(
                          text: "Edit Phone Number",
                          style:
                              appstyle(12, Constants.white, FontWeight.bold)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
