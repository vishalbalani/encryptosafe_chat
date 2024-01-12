import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/model/db_handle.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/provider/rsa_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatMessageTile extends ConsumerWidget {
  const ChatMessageTile({
    Key? key,
    required this.message,
    required this.sendByMe,
    required this.chatRoomId,
    required this.privateKeyDN,
  }) : super(key: key);

  final message;
  final privateKeyDN;

  final bool sendByMe;
  final String chatRoomId;
  Future<List<String>> getMessagesFromDatabase(String chatRoomId) async {
    final messages =
        await DatabaseHandler.instance.getMessagesForChatRoomId(chatRoomId);
    return messages;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: sendByMe
                  ? buildSentMessageBubble()
                  : buildReceivedMessageBubble(ref),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSentMessageBubble() {
    return FutureBuilder<List<String>>(
      future: getMessagesFromDatabase(chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the database result
          return CircularProgressIndicator(); // or any loading indicator
        } else if (snapshot.hasError) {
          // If an error occurs while fetching from the database
          return Text('Error: ${snapshot.error}');
        } else {
          // When the database result is available
          final messages = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: messages.map((sentMessage) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Constants.greyColor2,
                ),
                constraints: const BoxConstraints(maxWidth: 280),
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  sentMessage,
                  style: appstyle(
                    16,
                    Colors.black,
                    FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget buildReceivedMessageBubble(ref) {
    if (message['read'].isEmpty || message['read'] == '') {
      ref
          .read(firestoreProvider)
          .updateMessageReadStatus(chatRoomId, message['messageId']);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xff373E4E),
      ),
      constraints: const BoxConstraints(maxWidth: 280),
      child: Text(
        decrypt(message, privateKeyDN),
        style: appstyle(
          16,
          Constants.white,
          FontWeight.w400,
        ),
      ),
    );
  }
}
