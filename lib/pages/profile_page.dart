import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/pages/auth/login_page.dart';
import 'package:encryptosafe/pages/home_page.dart';
import 'package:encryptosafe/provider/auth_provider.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/custom_button.dart';
import 'package:encryptosafe/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController controllerNickname;

  final FocusNode focusNodeNickname = FocusNode();

  String name = '';
  String username = '';

  void redirectToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const HomePage()), // Replace HomePage() with your home page route
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    controllerNickname = TextEditingController();
    readLocal();
  }

  void readLocal() async {
    final data = await ref.read(firestoreProvider).readUserData();
    setState(() {
      name = data[0] ?? "";
      print(name);
      username = data[1] ?? "";
    });
    controllerNickname = TextEditingController(text: name);
  }

  @override
  void dispose() {
    controllerNickname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Username: $username",
            style: appstyle(18, Constants.white, FontWeight.bold),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Update Your Name",
                  style: appstyle(18, Constants.white, FontWeight.bold),
                ),
              ),
              CustomTextField(
                controller: controllerNickname,
                keyboardType: TextInputType.name,
                hintText: "Name",
                hintStyle: appstyle(16, Constants.darkBK, FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomButton(
                  onTap: () {
                    if (name != controllerNickname.text) {
                      ref.read(loadingProvider.notifier).state = true;
                      ref.read(authControllerProvider).updateName(
                          Name: controllerNickname.text,
                          context: context,
                          ref: ref);
                    }
                  },
                  width: Constants.width * 0.9,
                  height: Constants.height * 0.075,
                  color: Constants.darkBK,
                  color2: Constants.white,
                  text: "Update Name",
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
          ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Constants.grayLight),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Constants.white),
              ),
              onPressed: () {
                ref.read(AuthProvider).SignOut();
              },
              child: const Text("Logout")),
        ],
      ),
    );
  }
}
