import 'package:flutter_riverpod/flutter_riverpod.dart';

final navIndexProvider = StateProvider<int>((ref) {
  return 0; // Default index for the navigation bar
});
