import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptosafe/pages/auth/login_page.dart';
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

  void verifyOtp(
      {required BuildContext context,
      required String verificationId,
      required String smsCodeId,
      required String smsCode,
      required bool mounted,
      required String phone,
      required WidgetRef ref}) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // final UserCredential = await auth.signInWithCredential(credential);
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      final userDocRef = FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid);

      try {
        final userDocSnapshot = await userDocRef.get();

        if (!userDocSnapshot.exists) {
          var name = RandomUtils().getRandomName();
          var username = await RandomUtils().generateUniqueUsername(
            name: name,
            phoneNumber: phone,
          );

          await userCredential.user!.updateDisplayName(name);

          await userDocRef.set({
            "uid": userCredential.user!.uid,
            "username": username,
            "name": name,
            "phone": phone,
            "imageURL": "",
            "public": '',
            "is_online": true,
            "last_active": "",
            "fmc_token": "",
          });
        }
      } catch (firestoreError) {
        // Handle Firestore-related errors
      }

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteGenerator.main,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showAlertDialog(
          context: context, message: getFirebaseAuthErrorMessage(e));
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  String getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  void SignOut() {
    auth.signOut();
  }

  void sendOtp(
      {required BuildContext context,
      required String phone,
      required WidgetRef ref}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ref.read(loadingProvider.notifier).state = false;
          showAlertDialog(context: context, message: e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          ref.read(loadingProvider.notifier).state = false;
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
      ref.read(loadingProvider.notifier).state = false;
      showAlertDialog(context: context, message: e.toString());
    }
  }

  // Inside AuthProviderNotifier class or wherever you have access to the User instance
  void updateDisplayName(
      String displayName, BuildContext context, WidgetRef ref) async {
    try {
      // Get the current user
      User? currentUser = auth.currentUser;

      if (currentUser != null) {
        await currentUser.updateDisplayName(displayName);

        // Update display name in Firestore
        await FirebaseFirestore.instance
            .collection('user')
            .doc(currentUser.uid)
            .update({'name': displayName});
        showAlertDialog(context: context, message: 'Name Updated Successfully');
      } else {
        showAlertDialog(context: context, message: 'Something Went Wrong');
      }
    } catch (e) {
      showAlertDialog(context: context, message: e.toString());
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
  }
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
    required WidgetRef ref,
  }) {
    authProvider.verifyOtp(
        context: context,
        verificationId: verificationId,
        smsCodeId: smsCodeId,
        smsCode: smsCode,
        mounted: mounted,
        phone: phone,
        ref: ref);
  }

  void sendSms({
    required BuildContext context,
    required String phone,
    required WidgetRef ref,
  }) {
    authProvider.sendOtp(context: context, phone: phone, ref: ref);
  }

  String myID({required String myUuid}) {
    return myUuid;
  }

  void updateName(
      {required String Name,
      required BuildContext context,
      required WidgetRef ref}) {
    authProvider.updateDisplayName(Name, context, ref);
  }
}
