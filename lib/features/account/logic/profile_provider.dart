import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/account/logic/profile_notifier.dart';
import 'package:moblie_banking/features/account/logic/profile_state.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      final dio = ref.read(dioClientProvider);
      final storage = ref.read(secureStorageProvider);
      return ProfileNotifier(dio, storage);
    });
