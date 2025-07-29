import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moblie_banking/features/account/logic/profile_state.dart';
import 'package:moblie_banking/core/services/api_service.dart';
import 'package:moblie_banking/core/utils/secure_storage.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final DioClient dioClient;
  final SecureStorage storage;

  ProfileNotifier(this.dioClient, this.storage) : super(const ProfileState());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage({bool fromCamera = false}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        state = state.copyWith(
          selectedImage: File(image.path),
          isLoading: false,
          successMessage: 'ຮູບພາບຖືກເລືອກແລ້ວ',
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການເລືອກຮູບພາບ: $e',
      );
    }
  }

  Future<void> uploadProfileImage() async {
    if (state.selectedImage == null) return;

    try {
      state = state.copyWith(isUploading: true, errorMessage: null);

      // Convert image to base64
      final bytes = await state.selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = 'image/jpeg'; // Assuming JPEG format
      final dataUrl = 'data:$mimeType;base64,$base64Image';

      // Upload to API
      final response = await dioClient.clientV2.post(
        'update_profile',
        data: {'userprofile': dataUrl},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == 'Success') {
          state = state.copyWith(
            isUploading: false,
            selectedImage: null,
            successMessage: 'ອັບໂຫລດຮູບພາບສຳເລັດແລ້ວ',
          );
        } else {
          throw Exception(responseData['message'] ?? 'Upload failed');
        }
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການອັບໂຫລດ: $e',
      );
    }
  }

  Future<void> hideProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isImageHidden', true);

      state = state.copyWith(
        isImageHidden: true,
        successMessage: 'ບໍ່ສະແດງຮູບພາບແລ້ວ',
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການບໍ່ສະແດງຮູບພາບ: $e',
      );
    }
  }

  Future<void> showProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isImageHidden', false);

      state = state.copyWith(
        isImageHidden: false,
        successMessage: 'ສະແດງຮູບພາບແລ້ວ',
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'ເກີດຂໍ້ຜິດພາດໃນການສະແດງຮູບພາບ: $e');
    }
  }

  Future<void> loadImageVisibilityState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isHidden = prefs.getBool('isImageHidden') ?? false;

      state = state.copyWith(isImageHidden: isHidden);
    } catch (e) {
      // Silently handle error, use default value
      state = state.copyWith(isImageHidden: false);
    }
  }

  void clearMessages() {
    state = state.clearMessages();
  }
}
