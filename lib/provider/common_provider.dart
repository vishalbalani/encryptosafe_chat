import 'package:encryptosafe/model/db_handle.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final uidProvider = FutureProvider<String>((ref) async {
  final privateKeyMap = await DatabaseHandler.instance.getPrivateKey();
  return privateKeyMap!['id'] as String;
});

final chatRoomProvider =
    Provider<ChatRoomProvider>((ref) => ChatRoomProvider());

class ChatRoomProvider {
  String getChatRoomIdbyUsername(String a, String b) {
    return a.compareTo(b) < 0 ? "$a\_$b" : "$b\_$a";
  }
}
