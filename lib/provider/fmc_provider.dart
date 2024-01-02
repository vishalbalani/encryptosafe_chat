// Example within a Riverpod Provider
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fmcProvider = Provider((ref) {
  return FMCProvider(finstance: FirebaseMessaging.instance);
});

class FMCProvider {
  final FirebaseMessaging finstance;
  FMCProvider({required this.finstance});

  Future<void> getFirebaseMessagingToken(ref) async {
    await finstance.requestPermission();
    await finstance.getToken().then((t) {
      if (t != null) {
        ref.read(firestoreProvider).updatefmc(t);
      }
    });
  }
}
