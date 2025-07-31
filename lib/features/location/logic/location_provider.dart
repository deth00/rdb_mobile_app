import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'package:moblie_banking/features/location/logic/location_notifier.dart';
import 'package:moblie_banking/features/location/logic/location_state.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) {
    final apiService = ref.watch(dioClientProvider);
    return LocationNotifier(apiService);
  },
);
