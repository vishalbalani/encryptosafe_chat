import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            backgroundColor:
                MaterialStateProperty.all<Color>(Constants.grayLight),
            foregroundColor: MaterialStateProperty.all<Color>(Constants.white),
          ),
          onPressed: () {
            ref.read(AuthProvider).SignOut();
          },
          child: const Text("Logout")),
    );
  }
}
