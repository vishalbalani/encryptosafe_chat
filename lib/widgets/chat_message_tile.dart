import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatMessageTile extends ConsumerWidget {
  const ChatMessageTile({
    Key? key,
    required this.message,
    required this.sendByMe,
    required this.chatRoomId,
  }) : super(key: key);

  final message;

  final bool sendByMe;
  final String chatRoomId;

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Constants.greyColor2,
      ),
      constraints: const BoxConstraints(maxWidth: 280),
      child: Text(
        message['message'],
        style: appstyle(
          16,
          Colors.black,
          FontWeight.w400,
        ),
      ),
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
        message['message'],
        style: appstyle(
          16,
          Constants.white,
          FontWeight.w400,
        ),
      ),
    );
  }
}
