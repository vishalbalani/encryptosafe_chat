import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchProvider = Provider((ref) {
  return SearchProviderNotifier(
    instance: FirebaseFirestore.instance,
  );
});

class SearchProviderNotifier {
  final FirebaseFirestore instance;

  SearchProviderNotifier({required this.instance});

  Future<QuerySnapshot> search(String textSearch, int value) async {
    // textSearch = textSearch.toLowerCase();
    Query query = instance.collection("user");
    if (value == 1) {
      query = query
          .where("name", isGreaterThanOrEqualTo: textSearch)
          .where("name", isLessThan: "${textSearch}z");
    } else {
      query = query
          .where("username".toLowerCase(), isGreaterThanOrEqualTo: textSearch)
          .where("username".toLowerCase(), isLessThan: "${textSearch}z");
    }

    return await query.get();
  }
}
