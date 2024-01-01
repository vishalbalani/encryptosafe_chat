import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'dart:math';
import 'package:random_name_generator/random_name_generator.dart';

class RandomUtils {
  String getRandomName() {
    print("3");
    var random = Random();
    var zones = [
      Zone.france,
      Zone.us,
      Zone.uk,
      Zone.spain,
      Zone.catalonia,
      Zone.turkey,
    ];

    var randomZoneIndex = random.nextInt(zones.length);
    return RandomNames(zones[randomZoneIndex]).fullName();
  }

  Future<String> generateUniqueUsername({
    required String name,
    required String phoneNumber,
  }) async {
    print("2");
    String randomUid = randomAlphaNumeric(4);
    String randomName = name.substring(0, min(4, name.length));
    String randomPhoneNumber = phoneNumber.substring(0, 4);

    String username = '$randomUid$randomName$randomPhoneNumber';
    List<String> usernameChars = username.split('');

    // Shuffle the characters in the username
    usernameChars.shuffle();
    username = usernameChars.join('');
    print("1");

    final usersSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
        .get();

    if (usersSnapshot.docs.isNotEmpty) {
      // If a user with the same username already exists, try generating a new one
      return generateUniqueUsername(name: name, phoneNumber: phoneNumber);
    } else {
      print("0");
      return username;
    }
  }
}
