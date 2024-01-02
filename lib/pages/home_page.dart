import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/provider/fmc_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/custom_textfield.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:encryptosafe/widgets/user_tile_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController search = TextEditingController();
  late Future<Map<String, Map<String, dynamic>>> userDataMap;

  late Stream<QuerySnapshot<Map<String, dynamic>>> chatRoomsStream =
      const Stream.empty();

  @override
  void initState() {
    super.initState();
    readLocal();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains("pause")) {
        ref.read(firestoreProvider).updateActiveStatus(false);
      }
      if (message.toString().contains("resume")) {
        ref.read(firestoreProvider).updateActiveStatus(true);
      }
      return Future.value(message);
    });
  }

  Future<void> readLocal() async {
    ref.read(fmcProvider).getFirebaseMessagingToken(ref);
    final chatRoomsStreamResult =
        await ref.read(firestoreProvider).getChatRooms();

    // Assign the Stream<QuerySnapshot<Object?>> to chatRoomsStream
    chatRoomsStream =
        chatRoomsStreamResult as Stream<QuerySnapshot<Map<String, dynamic>>>;

    userDataMap = ref
        .read(firestoreProvider)
        .fetchUserDataForAllChatRooms(chatRoomsStream);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                child: TextWidget(
                  text: "Chats",
                  style: appstyle(18, Constants.white, FontWeight.bold),
                ),
              ),
              CustomTextField(
                hintText: "Search",
                controller: search,
                prefixIcon: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Icon(
                    AntDesign.search1,
                    color: Constants.grayLight,
                  ),
                ),
                suffixIcon: const Icon(
                  FontAwesome.sliders,
                  color: Constants.grayLight,
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Constants.white));
          } else if (snapshot.hasError) {
            return Center(
                child: TextWidget(
                    text: 'Error: Something went wrong!',
                    style: appstyle(16, Constants.white, FontWeight.bold)));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: TextWidget(
                    text: 'No chat room found',
                    style: appstyle(16, Constants.white, FontWeight.bold)));
          } else {
            return FutureBuilder<Map<String, Map<String, dynamic>>>(
              future: userDataMap,
              builder: (context, userDataSnapshot) {
                if (userDataSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    !userDataSnapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(color: Constants.white));
                }

                final userDataMap = userDataSnapshot.data!;

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final ds = snapshot.data!.docs[index];
                    final username =
                        ref.read(firestoreProvider).getUsername(ds.id);
                    if (userDataMap.containsKey(username)) {
                      return UserTile(
                        userData: userDataMap[username]!,
                        lastMessage: ds['lastMessage'],
                        time: ds['lastMessageSendTs'],
                        isMessageRead: false,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
