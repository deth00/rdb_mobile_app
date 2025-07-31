import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/account/logic/profile_provider.dart';
import 'package:moblie_banking/features/account/logic/profile_state.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  void initState() {
    super.initState();
    // Load the saved image visibility state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadImageVisibilityState();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final authstate = ref.watch(authNotifierProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final user = authstate.user;
    return Scaffold(
      appBar: GradientAppBar(title: 'ບັນຊີເງິນຝາກ'),
      body: Column(
        children: [
          SizedBox(height: fixedSize * 0.015),
          // Profile icon area
          Container(
            width: fixedSize * 0.29,
            height: fixedSize * 0.19,
            decoration: BoxDecoration(
              color: Color(0xFFF5EEDC),
              borderRadius: BorderRadius.circular(fixedSize * 0.001),
            ),
            child: Center(
              child: _buildProfileImage(
                user?.profile,
                fixedSize * 0.18,
                profileState,
              ),
            ),
          ),
          SizedBox(height: fixedSize * 0.01),
          // 3 buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixedSize * 0.002),
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.color1,
                        side: BorderSide(color: AppColors.color1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            fixedSize * 0.004,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await ref
                            .read(profileNotifierProvider.notifier)
                            .pickImage();
                      },
                      icon: Icon(Icons.photo_library, size: 16),
                      label: Text('ເລືອກຮູບ'),
                    ),
                  ),
                  // SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: profileState.isImageHidden
                            ? Colors.green
                            : AppColors.color1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            fixedSize * 0.004,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (profileState.isImageHidden) {
                          // Show image
                          await ref
                              .read(profileNotifierProvider.notifier)
                              .showProfileImage();
                        } else {
                          // Hide image
                          await ref
                              .read(profileNotifierProvider.notifier)
                              .hideProfileImage();
                        }
                      },
                      icon: Icon(
                        profileState.isImageHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 16,
                      ),
                      label: Text(
                        profileState.isImageHidden ? 'ສະແດງຮູບ' : 'ບໍ່ສະແດງຮູບ',
                      ),
                    ),
                  ),
                  // SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.color1,
                        side: BorderSide(color: AppColors.color1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            fixedSize * 0.004,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await ref
                            .read(profileNotifierProvider.notifier)
                            .pickImage(fromCamera: true);
                      },
                      icon: Icon(Icons.camera_alt, size: 16),
                      label: Text('ຖ່າຍຮູບ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: fixedSize * 0.018),
          // User info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fixedSize * 0.002),
            child: user == null
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      'ບໍ່ມີຂໍ້ມູນ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ຂໍ້ມູນຜູ້ໃຊ້',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.color1,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow('ຊື່:', user.firstName),
                        SizedBox(height: 8),
                        _buildInfoRow('ນາມສະກຸນ:', user.lastName),
                        SizedBox(height: 8),
                        _buildInfoRow('ເບີໂທລະສັບ:', user.phone),
                        SizedBox(height: 8),
                        _buildInfoRow('ລະຫັດຜູ້ໃຊ້:', user.userId.toString()),
                      ],
                    ),
                  ),
          ),

          // Status messages
          if (profileState.errorMessage != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: fixedSize * 0.002),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        profileState.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.red.shade700,
                        size: 16,
                      ),
                      onPressed: () {
                        ref
                            .read(profileNotifierProvider.notifier)
                            .clearMessages();
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),

          if (profileState.successMessage != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: fixedSize * 0.002),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  profileState.successMessage!,
                  style: TextStyle(color: Colors.green.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Loading indicator
          if (profileState.isUploading)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: fixedSize * 0.002),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'ກຳລັງອັບໂຫລດຮູບພາບ...',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ),
            ),

          // Spacer(),
          // Save button at the bottom
        ],
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.main),
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (profileState.selectedImage != null) {
                  await ref
                      .read(profileNotifierProvider.notifier)
                      .uploadProfileImage();
                }
              },
              label: Center(
                child: Text(
                  profileState.selectedImage != null
                      ? 'ອັບໂຫລດຮູບພາບ'
                      : 'ບັນທຶກ',
                  style: TextStyle(
                    fontSize: fixedSize * 0.015,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildProfileImage(
    String? profile,
    double size,
    ProfileState profileState,
  ) {
    // Show selected image if available (preview before upload)
    if (profileState.selectedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.001),
            child: Image.file(
              profileState.selectedImage!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
          // Preview indicator
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.edit, size: 12, color: Colors.white),
            ),
          ),
        ],
      );
    }

    // Show user's profile image if available and not hidden
    if (profile != null && profile.isNotEmpty && !profileState.isImageHidden) {
      if (profile.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: profile,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: size,
            height: size,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey, size: size * 0.7),
          ),
        );
      } else if (profile.startsWith('data:image/')) {
        // Decode base64
        final base64Str = profile.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        );
      } else {
        // Assume it's a path to be appended to your API
        return CachedNetworkImage(
          imageUrl: 'https://fund.nbb.com.la/api/v1/$profile',
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: size,
            height: size,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey, size: size * 0.7),
          ),
        );
      }
    }

    // Show hidden indicator if image is hidden
    if (profileState.isImageHidden && profile != null && profile.isNotEmpty) {
      return Stack(
        children: [
          Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey, size: size * 0.7),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.visibility_off, size: 12, color: Colors.white),
            ),
          ),
        ],
      );
    }

    // Default icon (same as home screen)
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(Icons.person, color: Colors.grey, size: size * 0.7),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
