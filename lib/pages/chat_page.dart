import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/helper/date_util.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/chat_message_tile.dart';
import 'package:encryptosafe/widgets/custom_textfield.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.peerData});
  final peerData;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  var uid;
  late String chatRoomId;
  late Stream<QuerySnapshot> messageStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void readLocal() async {
    setState(() {
      uid = ref.read(firestoreProvider).getUId();
    });

    chatRoomId = ref
        .read(firestoreProvider)
        .getChatRoomIdbyUsername(widget.peerData['uid']);

    getAndSetMessages();
  }

  void addMessage() {
    final String message = messageController.text.trim();

    if (message.isNotEmpty) {
      final now = DateTime.now().millisecondsSinceEpoch.toString();
      final String messageId = const Uuid().v1() + randomAlphaNumeric(10);

      final Map<String, dynamic> messageInfoMap = {
        "messageId": messageId,
        "message": message,
        "sendBy": uid,
        "send": now,
        "read": "",
        "time": FieldValue.serverTimestamp(),
      };

      ref
          .read(firestoreProvider)
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        final Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": now,
          "unreadCount": FieldValue.increment(1),
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": uid,
        };
        ref.read(firestoreProvider).updateLastMessageSend(
              chatRoomId,
              widget.peerData['fmc_token'],
              lastMessageInfoMap,
              ref,
            );
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

              return ChatMessageTile(
                message: message,
                sendByMe: isSentByMe,
                chatRoomId: chatRoomId,
              );
            },
          );
        }
      },
    );
  }

  Widget appBarWidget(bool isOnline, String lastActive, String name) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextWidget(
              text: isOnline
                  ? 'Online'
                  : MyDateUtil.getLastActiveTime(
                      context: context,
                      lastActive: lastActive,
                    ),
              style: appstyle(18, Constants.white, FontWeight.bold),
            ),
            TextWidget(
              text: name,
              style: appstyle(18, Constants.white, FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.darkBK,
        automaticallyImplyLeading: false,
        title: StreamBuilder(
          stream: ref
              .watch(firestoreProvider)
              .getUserInfoStream(widget.peerData['uid']),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: TextWidget(
                  text: widget.peerData["name"],
                  style: appstyle(18, Constants.white, FontWeight.bold),
                ),
              );
            } else {
              print(DateTime.now().toString());
              final userData = snapshot.data!.docs[0].data();
              return appBarWidget(
                userData['is_online'],
                userData['last_active'],
                userData['name'],
              );
            }
          },
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
