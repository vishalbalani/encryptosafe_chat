import 'package:encryptosafe/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            ref.read(AuthProvider).SignOut();
          },
          child: Text("Logout")),
    );
  }
}
