// Example within a Riverpod Provider
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

  Future<void> sendPushNotification(
      String fmc, String myName, String msg) async {
    try {
      final body = {
        "to": fmc,
        "notification": {
          "title": myName, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };
      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key= AAAAP8_jdDY:APA91bHOLef2-4Abx8kux1q4qhuSW4LRqky84xKfAhnQmqeXPAYE_s5eIFBtR-2I14ryGYVgu_E8ubjqgOXf_dFBA1_fcePreta7Fl0nGxEpDkIbYSfaztzz4SWnEeZRFPxD_T_KWzAC'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }
}
