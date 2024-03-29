// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDAAHtKpFislVGRXHJQjQLBcquhM3Kkf1o',
    appId: '1:274070729782:web:cb224350577d253657d497',
    messagingSenderId: '274070729782',
    projectId: 'encryptosafe-chat',
    authDomain: 'encryptosafe-chat.firebaseapp.com',
    storageBucket: 'encryptosafe-chat.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_l8nBmCJ2iDaQywWV4P4RWpY6uSNrNNI',
    appId: '1:274070729782:android:a1ca15ce1006cc1457d497',
    messagingSenderId: '274070729782',
    projectId: 'encryptosafe-chat',
    storageBucket: 'encryptosafe-chat.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAavht7ej_f04827vgNrksvVKT_fIMFYag',
    appId: '1:274070729782:ios:fde0a418bbd4e21257d497',
    messagingSenderId: '274070729782',
    projectId: 'encryptosafe-chat',
    storageBucket: 'encryptosafe-chat.appspot.com',
    iosBundleId: 'com.chatapp.encryptosafe',
  );
}
