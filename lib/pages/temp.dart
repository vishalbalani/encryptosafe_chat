// Widget chatMessageTile(String message, bool sendByMe) {
//   return Row(
//     mainAxisAlignment:
//         sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//     children: <Widget>[
//       Container(
//         padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//         constraints: BoxConstraints(maxWidth: 250),
//         decoration: BoxDecoration(
//           color: sendByMe ? Constants.greyColor2 : Color(0xff373E4E),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         margin: EdgeInsets.only(bottom: 10, left: sendByMe ? 0 : 10),
//         child: Text(message,
//             style: appstyle(16, sendByMe ? Colors.black : Constants.white,
//                 FontWeight.normal)),

//         // Text(
//         //   message,
//         //   style: TextStyle(color: sendByMe ? Constants.white : Colors.white),
//         // ),
//       ),
//     ],
//   );
// }
