import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterNotifier extends StateNotifier<int> {
  FilterNotifier() : super(0);

  void toggleFilterProvider(int value) {
    state = value;
  }
}

final filterSearchProvider = StateNotifierProvider<FilterNotifier, int>((ref) {
  return FilterNotifier();
});
