import 'package:hooks_riverpod/hooks_riverpod.dart';

class UidProviderNotifier extends StateNotifier<String> {
  UidProviderNotifier() : super("");

  void setUid(String uid) {
    state = uid;
  }
}

final UidProvider = StateNotifierProvider<UidProviderNotifier, String>((ref) {
  return UidProviderNotifier();
});
