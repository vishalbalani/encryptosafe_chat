import 'package:encryptosafe/model/db_handle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final privateKeyProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final privateKeyMap = await DatabaseHandler.instance.getPrivateKey();
  return privateKeyMap;
});

final privateKeyDNProvider = Provider<Map<String, dynamic>>((ref) {
  final privateKeyMap = ref.watch(privateKeyProvider);
  return privateKeyMap.maybeWhen(
    data: (privateKeyMap) => {
      'd': privateKeyMap?['d'] ?? '',
      'n': privateKeyMap?['n'] ?? '',
    },
    orElse: () => {
      'd': '',
      'n': ''
    }, // Return default values if private key not available
  );
});
