import 'dart:io';

class ProfileState {
  final bool isLoading;
  final bool isUploading;
  final File? selectedImage;
  final bool isImageHidden;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.isLoading = false,
    this.isUploading = false,
    this.selectedImage,
    this.isImageHidden = false,
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isUploading,
    File? selectedImage,
    bool? isImageHidden,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      selectedImage: selectedImage ?? this.selectedImage,
      isImageHidden: isImageHidden ?? this.isImageHidden,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  ProfileState clearMessages() {
    return copyWith(errorMessage: null, successMessage: null);
  }
}
