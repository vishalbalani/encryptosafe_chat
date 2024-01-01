import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/pages/chat_page.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/height_spacer.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:encryptosafe/widgets/width_spacer.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String lastMessage;
  final String time;
  final bool isMessageRead;

  const UserTile({
    super.key,
    required this.userData,
    required this.lastMessage,
    required this.time,
    required this.isMessageRead,
  });

  @override
  Widget build(BuildContext context) {
    final String name = userData['name'] ?? '';
    // final String imageUrl = userData['imageURL'] ?? '';

    // ImageProvider<Object>? imageProvider;
    // if (imageUrl.isEmpty || imageUrl == '') {
    //   imageProvider = AssetImage('assets/images/user1.png');
    // } else {
    //   imageProvider = NetworkImage(imageUrl);
    // }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatPage(peerData: userData),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: <Widget>[
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/user1.png'),
              maxRadius: 30,
            ),
            const WidthSpacer(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: name,
                    style: appstyle(
                      16,
                      Constants.white,
                      FontWeight.normal,
                    ),
                  ),
                  const HeightSpacer(height: 6),
                  TextWidget(
                      text: lastMessage,
                      style: appstyle(13, Constants.white,
                          isMessageRead ? FontWeight.bold : FontWeight.normal)),
                ],
              ),
            ),
            TextWidget(
                text: time,
                style: appstyle(12, Constants.white,
                    isMessageRead ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
