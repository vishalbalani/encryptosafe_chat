import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:flutter/material.dart';

class ChatMessageTile extends StatelessWidget {
  const ChatMessageTile(
      {super.key, required this.message, required this.sendByMe});
  final String message;
  final bool sendByMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      sendByMe ? Constants.greyColor2 : const Color(0xff373E4E),
                ),
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  message,
                  style: appstyle(
                    16,
                    sendByMe ? Colors.black : Constants.white,
                    FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
