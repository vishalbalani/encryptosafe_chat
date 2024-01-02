import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/model/db_handle.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/custom_textfield.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.peerData});
  final peerData;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late TextEditingController messageController;
  late String uid;
  late String chatRoomId;
  late Stream<QuerySnapshot> messageStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    readLocal();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void readLocal() async {
    final privateKeyMap = await DatabaseHandler.instance.getPrivateKey();

    if (privateKeyMap != null) {
      setState(() {
        uid = privateKeyMap['id'];
      });
    }
    chatRoomId = getChatRoomIdbyUsername(widget.peerData['uid'], uid);

    getAndSetMessages();
  }

  String getChatRoomIdbyUsername(String a, String b) {
    return a.compareTo(b) < 0 ? "$a\_$b" : "$b\_$a";
  }

  void addMessage() {
    final String message = messageController.text.trim();

    if (message.isNotEmpty) {
      final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('h:mma').format(now);
      final String messageId = const Uuid().v1() + randomAlphaNumeric(10);

      final Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": uid,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
      };

      ref
          .read(firestoreProvider)
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        final Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": uid,
        };
        ref
            .read(firestoreProvider)
            .updateLastMessageSend(chatRoomId, lastMessageInfoMap);
      });

      messageController.clear();
    }
  }

  void getAndSetMessages() {
    messageStream = ref.read(firestoreProvider).getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  Widget chatMessage() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Constants.white,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            reverse: true,
            itemBuilder: (context, index) {
              final DocumentSnapshot message = snapshot.data!.docs[index];
              final bool isSentByMe = message['sendBy'] == uid;

              return chatMessageTile(
                message['message'],
                isSentByMe,
              );
            },
          );
        }
      },
    );
  }

  Widget chatMessageTile(String message, bool sendByMe) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.darkBK,
        automaticallyImplyLeading: false,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextWidget(
              text: widget.peerData['name'],
              style: appstyle(18, Constants.white, FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatMessage(),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomTextField(
                    hintText: "Type your message here...",
                    hintStyle: appstyle(16, Colors.white38, FontWeight.w400),
                    boxColor: Constants.darkBK,
                    controller: messageController,
                    fontStyle: appstyle(18, Constants.white, FontWeight.normal),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(14),
                      child: const Icon(
                        AntDesign.addfile,
                        color: Constants.grayLight,
                      ),
                    ),
                    suffixIcon: InkWell(
                      onTap: addMessage,
                      child: const Icon(
                        FontAwesome.send,
                        color: Constants.grayLight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
