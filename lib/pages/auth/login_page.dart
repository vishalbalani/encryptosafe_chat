import 'package:country_picker/country_picker.dart';
import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/provider/auth_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/custom_button.dart';
import 'package:encryptosafe/widgets/custom_dialog.dart';
import 'package:encryptosafe/widgets/custom_textfield.dart';
import 'package:encryptosafe/widgets/height_spacer.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController phone = TextEditingController();

  Country country = Country(
    phoneCode: "91",
    countryCode: "IND",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "",
  );

  sendCodeToUser() {
    if (phone.text.isEmpty || phone.text.length < 10) {
      return showAlertDialog(
        context: context,
        message: "Please enter your phone number",
      );
    } else {
      ref.read(loadingProvider.notifier).state = true;
      ref.read(authControllerProvider).sendSms(
          context: context,
          phone: '+${country.phoneCode}${phone.text}',
          ref: ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: SvgPicture.asset(
                  "assets/images/onboard.svg",
                  width: 300,
                ),
              ),
              const HeightSpacer(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16.w),
                child: TextWidget(
                  text: "Please enter your phone number",
                  style: appstyle(17, Constants.white, FontWeight.w500),
                ),
              ),
              const HeightSpacer(height: 20),
              Center(
                child: CustomTextField(
                  controller: phone,
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(14),
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          countryListTheme: CountryListThemeData(
                            backgroundColor: Constants.darkBK,
                            bottomSheetHeight: Constants.height * 0.6,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          onSelect: (code) {
                            setState(() {
                              country = code;
                            });
                          },
                        );
                      },
                      child: TextWidget(
                        text: "${country.flagEmoji} + ${country.phoneCode}",
                        style: appstyle(
                          18,
                          Constants.darkBK,
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  hintText: "Enter phone number",
                  hintStyle: appstyle(16, Constants.darkBK, FontWeight.w600),
                ),
              ),
              const HeightSpacer(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomButton(
                  onTap: () {
                    sendCodeToUser();
                  },
                  width: Constants.width * 0.9,
                  height: Constants.height * 0.075,
                  color: Constants.darkBK,
                  color2: Constants.white,
                  text: "Send Code",
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
