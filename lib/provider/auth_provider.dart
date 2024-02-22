import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptosafe/widgets/custom_dialog.dart';
import 'package:encryptosafe/widgets/random_utils.dart';
import 'package:encryptosafe/widgets/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AuthProvider = Provider((ref) {
  return AuthProviderNotifier(auth: FirebaseAuth.instance);
});

class AuthProviderNotifier {
  final FirebaseAuth auth;

  AuthProviderNotifier({required this.auth});

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
    required String phone,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final UserCredential = await auth.signInWithCredential(credential);


      final userDocRef = FirebaseFirestore.instance
          .collection('user')
          .doc(UserCredential.user!.uid);

      final userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        
      } else {
        var name = RandomUtils().getRandomName();
        var username = await RandomUtils().generateUniqueUsername(
          name: name,
          phoneNumber: phone,
        );
        await UserCredential.user!.updateDisplayName(name);
        await userDocRef.set({
          "uid": UserCredential.user!.uid,
          "username": username,
          "name": name,
          "phone": phone,
          "imageURL": "",
          "public": '',
          "is_online": true,
          "last_active": "",
          "fmc_token": ""
        });
      }

      

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteGenerator.main,
        (route) => false,
      );
    } on FirebaseAuth catch (e) {
      showAlertDialog(context: context, message: e.toString());
    }
  }

  void SignOut() {
    auth.signOut();
  }

  void sendOtp({required BuildContext context, required String phone}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          showAlertDialog(context: context, message: e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteGenerator.otp,
            (route) => false,
            arguments: {
              'phone': phone,
              'smsCodeId': verificationId,
            },
          );
        },
        codeAutoRetrievalTimeout: (String smsCodeId) {},
      );
    } on FirebaseAuth catch (e) {
      showAlertDialog(context: context, message: e.toString());
    }
  }

  // Inside AuthProviderNotifier class or wherever you have access to the User instance
  // void updateDisplayName(String displayName) async {
  //   try {
  //     // Get the current user
  //     User? currentUser = auth.currentUser;

  //     if (currentUser != null) {
  //       await currentUser.updateDisplayName(displayName);

  //       // Update display name in Firestore
  //       await FirebaseFirestore.instance
  //           .collection('user')
  //           .doc(currentUser.uid)
  //           .update({'name': displayName});

  //       print('Display name updated successfully: $displayName');
  //     } else {
  //       print('User not found.');
  //     }
  //   } catch (e) {
  //     print('Error updating display name: $e');
  //   }
  // }
}

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(AuthProvider);
  return AuthController(authProvider: authRepository);
});

class AuthController {
  final AuthProviderNotifier authProvider;

  AuthController({required this.authProvider});

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
    required String phone,
  }) {
    authProvider.verifyOtp(
        context: context,
        verificationId: verificationId,
        smsCodeId: smsCodeId,
        smsCode: smsCode,
        mounted: mounted,
        phone: phone);
  }

  void sendSms({
    required BuildContext context,
    required String phone,
  }) {
    authProvider.sendOtp(context: context, phone: phone);
  }

  String myID({required String myUuid}) {
    return myUuid;
  }
}
