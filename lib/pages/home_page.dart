import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/model/db_handle.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/provider/uid_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/custom_textfield.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:encryptosafe/widgets/user_tile_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController search = TextEditingController();
  late Future<Map<String, Map<String, dynamic>>> userDataMap;
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatRoomsStream =
      const Stream.empty();

  var uid;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  Future<void> readLocal() async {
    final privateKeyMap = await DatabaseHandler.instance.getPrivateKey();

    if (privateKeyMap != null) {
      setState(() {
        uid = privateKeyMap['id'];
      });

      ref.read(UidProvider.notifier).setUid(uid);

      final chatRoomsStreamResult =
          await ref.read(firestoreProvider).getChatRooms(uid);

      // Assign the Stream<QuerySnapshot<Object?>> to chatRoomsStream
      chatRoomsStream =
          chatRoomsStreamResult as Stream<QuerySnapshot<Map<String, dynamic>>>;

      userDataMap = fetchUserDataForAllChatRooms(chatRoomsStream);
    }
  }

  Future<Map<String, Map<String, dynamic>>> fetchUserDataForAllChatRooms(
      Stream<QuerySnapshot<Map<String, dynamic>>> chatStream) async {
    final chatRoomsSnapshot = await chatStream.first;
    final usernames = chatRoomsSnapshot.docs
        .map((ds) => ds.id.replaceAll("_", "").replaceAll(uid, ""))
        .toSet();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', whereIn: usernames.toList())
        .get();

    return {for (var doc in querySnapshot.docs) doc.id: doc.data()};
  }

  @override
  Widget build(BuildContext context) {
    // Return a loading or placeholder widget while uid is being fetched
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error: Something went wrong!'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No chat room found'),
            );
          } else {
            return FutureBuilder<Map<String, Map<String, dynamic>>>(
              future: userDataMap,
              builder: (context, userDataSnapshot) {
                if (userDataSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    !userDataSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userDataMap = userDataSnapshot.data!;

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final ds = snapshot.data!.docs[index];
                    final username =
                        ds.id.replaceAll("_", "").replaceAll(uid, "");

                    if (userDataMap.containsKey(username)) {
                      return UserTile(
                        userData: userDataMap[username]!,
                        lastMessage: ds['lastMessage'],
                        time: ds['lastMessageSendTs'],
                        isMessageRead: ds['lastMessageRead'],
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
