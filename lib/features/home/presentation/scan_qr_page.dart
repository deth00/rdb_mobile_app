import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/home/logic/qr_provider.dart';
import 'package:moblie_banking/features/home/logic/qr_state.dart';
import 'package:go_router/go_router.dart';

class ScanQRPage extends ConsumerStatefulWidget {
  const ScanQRPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends ConsumerState<ScanQRPage> {
  bool isProcessing = false;
  bool hasNavigated = false; // Add flag to prevent multiple navigations
  String? lastScannedQR;
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    // Clear any previous QR state when entering the scan page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(qrNotifierProvider.notifier).clearError();
        // Reset navigation flag when entering scan page
        hasNavigated = false;
      }
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    // Don't use ref in dispose method as it can cause StateError
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      // Prevent processing if already navigating or processing
      if (isProcessing || hasNavigated) return;

      final String? code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        isProcessing = true;
        lastScannedQR = code;

        try {
          await ref.read(qrNotifierProvider.notifier).decodeQR(code);
          final qrState = ref.read(qrNotifierProvider);

          if (qrState.decodedQRData != null &&
              qrState.decodedQRData!.isNotEmpty) {
            if (mounted && !hasNavigated) {
              // Debug logging
              _logQRData(qrState.decodedQRData!);

              // Extract account number from decoded data with better validation
              final accountNumber = _extractAccountNumber(
                qrState.decodedQRData!,
              );

              if (accountNumber != null &&
                  accountNumber.isNotEmpty &&
                  _isValidAccountNumber(accountNumber)) {
                // Set navigation flag to prevent multiple navigations
                setState(() {
                  hasNavigated = true;
                  isProcessing = false;
                });

                // Stop camera scanning to prevent further scans
                await cameraController.stop();

                // Navigate to transfer page using pushReplacement to prevent back navigation
                if (mounted) {
                  context.pushReplacementNamed(
                    'addTransferMoney',
                    pathParameters: {'acno': accountNumber},
                  );
                }
              } else {
                if (mounted) {
                  showCustomSnackBar(
                    context,
                    'QR Code ບໍ່ມີຂໍ້ມູນເລກບັນຊີທີ່ຖືກຕ້ອງ',
                    isError: true,
                  );
                  // Reset processing state for invalid QR
                  setState(() {
                    isProcessing = false;
                  });
                }
              }
            }
          } else {
            if (mounted) {
              showCustomSnackBar(
                context,
                'ບໍ່ສາມາດຖອດລະຫັດ QR Code ໄດ້',
                isError: true,
              );
              // Reset processing state for failed decoding
              setState(() {
                isProcessing = false;
              });
            }
          }
        } catch (e) {
          if (mounted) {
            showCustomSnackBar(
              context,
              'ເກີດຂໍ້ຜິດພາດໃນການປະມວນຜົນ QR Code: $e',
              isError: true,
            );
            // Reset processing state for errors
            setState(() {
              isProcessing = false;
            });
          }
        }
        break; // Process only the first barcode
      }
    }
  }

  /// Debug method to log QR data for troubleshooting
  void _logQRData(Map<String, dynamic> decodedData) {
    print('=== QR Debug Info ===');
    print('Raw QR Data: $decodedData');
    print('Keys: ${decodedData.keys.toList()}');

    // Try to find account number
    final accountNumber = _extractAccountNumber(decodedData);
    print('Extracted Account Number: $accountNumber');

    if (accountNumber != null) {
      print('Account Number Valid: ${_isValidAccountNumber(accountNumber)}');
    }
    print('=====================');
  }

  /// Extract account number from decoded QR data with multiple fallback options
  String? _extractAccountNumber(Map<String, dynamic> decodedData) {
    // Try multiple possible paths for account number
    final possiblePaths = [
      decodedData['34']?['03'],
      decodedData['accountNumber'],
      decodedData['acno'],
      decodedData['account'],
      decodedData['acc'],
      decodedData['number'],
      decodedData['account_number'],
      decodedData['account_no'],
      decodedData['ac_no'],
    ];

    for (final path in possiblePaths) {
      if (path != null && path.toString().isNotEmpty) {
        final accountNumber = path.toString().trim();
        // Clean the account number (remove non-digit characters)
        final cleanNumber = accountNumber.replaceAll(RegExp(r'[^\d]'), '');
        if (_isValidAccountNumber(cleanNumber)) {
          return cleanNumber;
        }
      }
    }

    // If no direct path found, search recursively in nested objects
    return _searchAccountNumberRecursively(decodedData);
  }

  /// Recursively search for account number in nested JSON structure
  String? _searchAccountNumberRecursively(dynamic data) {
    if (data is Map<String, dynamic>) {
      for (final entry in data.entries) {
        final key = entry.key.toLowerCase();
        final value = entry.value;

        // Check if key suggests this might be an account number
        if (key.contains('account') ||
            key.contains('acno') ||
            key.contains('number')) {
          if (value != null && value.toString().isNotEmpty) {
            final strValue = value.toString().trim();
            // Clean the account number (remove non-digit characters)
            final cleanNumber = strValue.replaceAll(RegExp(r'[^\d]'), '');
            if (_isValidAccountNumber(cleanNumber)) {
              return cleanNumber;
            }
          }
        }

        // Recursively search in nested objects
        if (value is Map<String, dynamic> || value is List) {
          final result = _searchAccountNumberRecursively(value);
          if (result != null) {
            return result;
          }
        }
      }
    } else if (data is List) {
      for (final item in data) {
        final result = _searchAccountNumberRecursively(item);
        if (result != null) {
          return result;
        }
      }
    }

    return null;
  }

  /// Validate account number format
  bool _isValidAccountNumber(String accountNumber) {
    if (accountNumber.isEmpty) return false;

    // Remove any non-digit characters
    final cleanNumber = accountNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a reasonable length for an account number (typically 8-20 digits)
    if (cleanNumber.length < 8 || cleanNumber.length > 20) return false;

    // Check if it contains only digits
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) return false;

    return true;
  }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // Prevent dismissing by tapping outside
  //     builder: (context) => AlertDialog(
  //       title: const Text('ຂໍ້ຜິດພາດ'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(message),
  //           const SizedBox(height: 8),
  //           if (lastScannedQR != null) ...[
  //             const SizedBox(height: 8),
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.shade100,
  //                 borderRadius: BorderRadius.circular(4),
  //               ),
  //               child: Text(
  //                 'QR Code: ${lastScannedQR!.substring(0, lastScannedQR!.length > 50 ? 50 : lastScannedQR!.length)}${lastScannedQR!.length > 50 ? '...' : ''}',
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   color: Colors.grey.shade600,
  //                   fontFamily: 'monospace',
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             setState(() {
  //               isProcessing = false;
  //             });
  //           },
  //           child: const Text('ຍົກເລີກ'),
  //         ),
  //         if (lastScannedQR != null)
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _retryScan();
  //             },
  //             child: const Text('ລອງໃໝ່'),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  void _retryScan() {
    if (lastScannedQR != null) {
      setState(() {
        isProcessing = true;
      });
      ref.read(qrNotifierProvider.notifier).retryDecodeQR(lastScannedQR!);
    }
  }

  void _cancelScanning() {
    if (isProcessing || hasNavigated) {
      setState(() {
        isProcessing = false;
        hasNavigated = false;
      });
      // Navigate back to home or previous screen
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrState = ref.watch(qrNotifierProvider);

    return WillPopScope(
      onWillPop: () async {
        // If already navigating, prevent going back to avoid multiple instances
        if (hasNavigated) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'ສະແກນ QR Code',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.main),
          ),
          leading: (isProcessing || hasNavigated)
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _cancelScanning,
                )
              : null,
          actions: [
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              onPressed: (isProcessing || hasNavigated)
                  ? null
                  : () => cameraController.toggleTorch(),
            ),
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              onPressed: (isProcessing || hasNavigated)
                  ? null
                  : () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: _onDetect,
                  ),
                  // Overlay for scanning area
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (isProcessing || hasNavigated)
                              ? Colors.grey
                              : Colors.green,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  // Loading overlay
                  if (isProcessing || hasNavigated || qrState.isLoading)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hasNavigated
                                  ? 'ກຳລັງເປີດໜ້າຕ່າງໂອນເງິນ...'
                                  : 'ກຳລັງປະມວນຜົນ QR Code...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            if (hasNavigated) ...[
                              const SizedBox(height: 8),
                              const Text(
                                'ກະລຸນາລໍຖ້າ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: (isProcessing || hasNavigated)
                            ? Colors.grey
                            : Colors.green,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      hasNavigated
                          ? 'ກຳລັງເປີດໜ້າຕ່າງໂອນເງິນ...'
                          : 'ຈັດ QR Code ໃຫ້ຢູ່ໃນກອບສີຂຽວເພື່ອສະແກນ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: (isProcessing || hasNavigated)
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Show processing status
                  if (isProcessing || hasNavigated)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hasNavigated
                                  ? 'ກຳລັງເປີດໜ້າຕ່າງໂອນເງິນ ກະລຸນາລໍຖ້າ'
                                  : 'ກຳລັງປະມວນຜົນ QR Code ກະລຸນາລໍຖ້າ',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
