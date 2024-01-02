import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptosafe/provider/fmc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firestoreProvider = Provider((ref) {
  return FireStoreProviderNotifier(
      instance: FirebaseFirestore.instance,
      user: FirebaseAuth.instance.currentUser!);
});

class FireStoreProviderNotifier {
  final FirebaseFirestore instance;
  final User user;

  FireStoreProviderNotifier({required this.instance, required this.user});

  String getUId() {
    return user.uid;
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot =
        await instance.collection("chatrooms").doc(chatRoomId).get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  getUsername(String chatroomid) {
    return chatroomid.replaceAll("_", "").replaceAll(user.uid, "");
  }

  updateLastMessageSend(String chatRoomId, String fmc,
      Map<String, dynamic> lastMessageInfoMap, ref) {
    return instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap)
        .then((value) => {
              ref.read(fmcProvider).sendPushNotification(
                  fmc, user.displayName, lastMessageInfoMap['lastMessage'])
            });
  }

  updatefmc(String fmc) {
    return instance.collection("user").doc(user.uid).update({"fmc_token": fmc});
  }

  Stream<QuerySnapshot> getChatRoomMessages(chatRoomId) {
    return instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    return instance
        .collection("chatrooms")
        .orderBy("time", descending: true)
        .where("users", arrayContains: user.uid)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await instance
        .collection("user")
        .where("uid", isEqualTo: username)
        .get();
  }

  Future<Map<String, Map<String, dynamic>>> fetchUserDataForAllChatRooms(
      Stream<QuerySnapshot<Map<String, dynamic>>> chatStream) async {
    final chatRoomsSnapshot = await chatStream.first;
    final usernames = chatRoomsSnapshot.docs
        .map((ds) => ds.id.replaceAll("_", "").replaceAll(user.uid, ""))
        .toSet();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', whereIn: usernames.toList())
        .get();

    final userDataMap = {
      for (var doc in querySnapshot.docs) doc.id: doc.data()
    };

    return userDataMap;
  }

  String getChatRoomIdbyUsername(String a) {
    final b = user.uid;
    return a.compareTo(b) < 0 ? "$a\_$b" : "$b\_$a";
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfoStream(uid) {
    return instance.collection('user').where('uid', isEqualTo: uid).snapshots();
  }

  Future<void> updateActiveStatus(bool isOnline) async {
    instance.collection('user').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}
