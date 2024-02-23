import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/provider/firestore_provider.dart';
import 'package:encryptosafe/widgets/appStyle.dart';
import 'package:encryptosafe/widgets/height_spacer.dart';
import 'package:encryptosafe/widgets/text_widget.dart';
import 'package:encryptosafe/widgets/width_spacer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserTileFind extends ConsumerWidget {
  final Map<String, dynamic> userData;
  final Function() onTapAction;

  const UserTileFind(
      {super.key, required this.userData, required this.onTapAction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentUid = ref.read(firestoreProvider).getUId();
    final String name = userData['name'] ?? '';
    final String uid = userData['uid'] ?? '';

    // final String imageUrl = userData['imageURL'] ?? '';
    final String username = userData['username'] ?? '';

    return Visibility(
      visible: uid != currentUid,
      child: InkWell(
        onTap: onTapAction,
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
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Constants.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
