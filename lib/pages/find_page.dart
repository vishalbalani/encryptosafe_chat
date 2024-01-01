import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/pages/chat_page.dart';
import 'package:encryptosafe/provider/filter_provider.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/provider/search_provider.dart';
import 'package:encryptosafe/provider/uid_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/custom_textfield.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:encryptosafe/widgets/user_tile_search.dart';
import 'package:encryptosafe/widgets/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_group_v2/radio_group_v2.dart';

class FindPage extends ConsumerStatefulWidget {
  const FindPage({Key? key}) : super(key: key);

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends ConsumerState<FindPage> {
  TextEditingController gSearchController = TextEditingController();
  var uid;

  @override
  void initState() {
    getUid();
    super.initState();
  }

  void getUid() async {
    uid = await ref.read(UidProvider);
  }

  @override
  void dispose() {
    gSearchController.dispose();
    super.dispose();
  }

  void onTapAction(QueryDocumentSnapshot snapshot) {
    var chatRoomId = getChatRoomIdbyUsername(uid!, snapshot['uid']);
    Map<String, dynamic> chatRoomInfoMap = {
      "users": [uid, snapshot['uid']],
    };
    ref.read(firestoreProvider).createChatRoom(chatRoomId, chatRoomInfoMap);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatPage(
        peerData: snapshot,
      ),
    ));
  }

  getChatRoomIdbyUsername(String a, String b) {
    return a.compareTo(b) < 0 ? "$a\_$b" : "$b\_$a";
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(filterSearchProvider);
    final SearchProvider = ref.watch(searchProvider);
    RadioGroupController myController = RadioGroupController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                child: TextWidget(
                  text: "Find Friends",
                  style: appstyle(18, Constants.white, FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                      text: "Search by",
                      style: appstyle(16, Constants.white, FontWeight.bold)),
                  const WidthSpacer(width: 10),
                  RadioGroup(
                    controller: myController,
                    onChanged: (value) {
                      ref
                          .read(filterSearchProvider.notifier)
                          .toggleFilterProvider(value == "Name" ? 1 : 0);
                    },
                    values: const [
                      "Username",
                      "Name",
                    ],
                    indexOfDefault: ref.read(filterSearchProvider),
                    orientation: RadioGroupOrientation.horizontal,
                    decoration: RadioGroupDecoration(
                      labelStyle:
                          appstyle(16, Constants.white, FontWeight.bold),
                      activeColor: Constants.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextField(
                  hintText: "Search",
                  controller: gSearchController,
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(14),
                    child: GestureDetector(
                      onTap: null,
                      child: const Icon(
                        AntDesign.search1,
                        color: Constants.grayLight,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    SearchProvider.search(
                        value, filter); // Trigger the search logic
                    setState(() {}); // Update the UI after search
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: SearchProvider.search(gSearchController.text, filter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final userData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return UserTileFind(
                  userData: userData,
                );
              },
            );
          }
        },
      ),
    );
  }
}
