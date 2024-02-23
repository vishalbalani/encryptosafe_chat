import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/helper/date_util.dart';
import 'package:encryptosafe/pages/chat_page.dart';
import 'package:encryptosafe/pages/home_page.dart';
import 'package:encryptosafe/provider/filter_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/height_spacer.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:encryptosafe/widgets/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserTile extends ConsumerWidget {
  final Map<String, dynamic> userData;
  final String lastMessage;
  final String time;
  final int count;
  final bool isSentByMe;

  const UserTile({
    Key? key,
    required this.userData,
    required this.lastMessage,
    required this.time,
    required this.count,
    required this.isSentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterSearch = ref.watch(filterNameProvider);
    final String name = userData['name'] ?? '';
    final formatedtime = MyDateUtil.DataTimeinAMPM(time);

    bool isSentMessage = isSentByMe;
    FontWeight messageFontWeight = FontWeight.normal;
    String messageText = lastMessage;
    bool showDot = false;

    if (!isSentMessage) {
      if (count > 0) {
        messageText = '$count new messages';
        messageFontWeight = FontWeight.bold;
        showDot = true;
      }
    }

    return Visibility(
      visible: name.toLowerCase().contains(filterSearch.toLowerCase()),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return ChatPage(peerData: userData);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Stack(
            children: [
              Row(
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
                          text: messageText,
                          style: appstyle(
                            13,
                            Constants.white,
                            messageFontWeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showDot)
                    const Icon(
                      Icons.circle_rounded,
                      color: Constants.white,
                      size: 16,
                    ),
                  const WidthSpacer(
                      width: 16), // Spacer between message and time
                  TextWidget(
                    text: formatedtime,
                    style: appstyle(
                      12,
                      Constants.white,
                      messageFontWeight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
