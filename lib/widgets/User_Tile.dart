// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:encryptosafe/pages/chat_page.dart';
// import 'package:encryptosafe/provider/firestore_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class ChatRoomListTile extends ConsumerStatefulWidget {
//   var peerData;
//   ChatRoomListTile({
//     required this.peerData,
//   });

//   @override
//   ConsumerState<ChatRoomListTile> createState() => _ChatRoomListTileState();
// }

// class _ChatRoomListTileState extends ConsumerState<ChatRoomListTile> {
//   // String profilePicUrl = "", name = "", username = "", peerId = "";
//   // late QuerySnapshot querySnapshot;

//   // getthisUserInfo() async {
//   //   peerId = widget.chatRoomId.replaceAll("_", "").replaceAll(widget.uid, "");
//   //   QuerySnapshot querySnapshot =
//   //       await ref.read(firestoreProvider).getUserInfo(peerId);
//   //   name = "${querySnapshot.docs[0]["name"]}";
//   //   profilePicUrl = "${querySnapshot.docs[0]["imageURL"]}";
//   //   username = "${querySnapshot.docs[0]["username"]}";
//   //   setState(() {});
//   // }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ChatPage(
//                       peerData: widget.peerData,
//                     )));
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 10.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: 10.0,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Text(
//                   widget.peerData[],
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 17.0,
//                       fontWeight: FontWeight.w500),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 2,
//                   child: Text(
//                     widget.lastMessage,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15.0,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//             Spacer(),
//             Text(
//               widget.time,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
