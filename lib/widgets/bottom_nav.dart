import 'package:encryptosafe/constants/constants.dart';
import 'package:encryptosafe/pages/find_page.dart';
import 'package:encryptosafe/pages/gpt_page.dart';
import 'package:encryptosafe/pages/home_page.dart';
import 'package:encryptosafe/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _index = 0;

  void onClick(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = const HomePage();
    switch (_index) {
      case 1:
        currentScreen = const FindPage();
        break;
      case 2:
        currentScreen = const GPTPage();
        break;
      case 3:
        currentScreen = const ProfilePage();
        break;
      default:
        break;
    }
    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: SizedBox(
        height: 70.w,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Constants.darkBK, // Set the background color
            selectedItemColor: Constants.white, // Set the selected item color
            unselectedItemColor:
                Constants.grayDark, // Set the unselected item color
            selectedFontSize: 12, // Adjust selected item font size
            unselectedFontSize: 12, // Adjust unselected item font size
            currentIndex: _index, // Pass _index to highlight the selected item
            onTap: onClick, // Invoke onClick method on item selection
            type: BottomNavigationBarType.fixed,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  AntDesign.home,
                  size: 30,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  AntDesign.addusergroup,
                  size: 30,
                ),
                label: "Find",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  AntDesign.rocket1,
                  size: 30,
                ),
                label: "GPT",
              ),
              BottomNavigationBarItem(
                icon: Icon(AntDesign.user),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
