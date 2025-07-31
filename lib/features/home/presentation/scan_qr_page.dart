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
  String? lastScannedQR;
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    // Clear any previous QR state when entering the scan page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(qrNotifierProvider.notifier).clearError();
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
      if (isProcessing) return;

      final String? code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        isProcessing = true;
        lastScannedQR = code;

        try {
          await ref.read(qrNotifierProvider.notifier).decodeQR(code);
          final qrState = ref.read(qrNotifierProvider);

          if (qrState.decodedQRData != null &&
              qrState.decodedQRData!.isNotEmpty) {
            if (mounted) {
              // Debug logging
              _logQRData(qrState.decodedQRData!);

              // Extract account number from decoded data with better validation
              final accountNumber = _extractAccountNumber(
                qrState.decodedQRData!,
              );

              if (accountNumber != null &&
                  accountNumber.isNotEmpty &&
                  _isValidAccountNumber(accountNumber)) {
                // Reset processing state before navigation
                setState(() {
                  isProcessing = false;
                });

                // Navigate to transfer page
                context.pushNamed(
                  'addTransferMoney',
                  pathParameters: {'acno': accountNumber},
                );
              } else {
                showCustomSnackBar(
                  context,
                  'QR Code ບໍ່ມີຂໍ້ມູນເລກບັນຊີທີ່ຖືກຕ້ອງ',
                  isError: true,
                );
              }
            }
            // } else if (qrState.errorMessage != null) {
            //   if (mounted) {
            //     showCustomSnackBar(context, qrState.errorMessage!);
            //   }
          } else {
            if (mounted) {
              showCustomSnackBar(
                context,
                'ບໍ່ສາມາດຖອດລະຫັດ QR Code ໄດ້',
                isError: true,
              );
            }
          }
        } catch (e) {
          if (mounted) {
            showCustomSnackBar(
              context,
              'ເກີດຂໍ້ຜິດພາດໃນການປະມວນຜົນ QR Code: $e',
              isError: true,
            );
          }
        } finally {
          if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    final qrState = ref.watch(qrNotifierProvider);

    // Listen for QR state changes
    // ref.listen<QRState>(qrNotifierProvider, (previous, next) {
    //   // Handle successful QR decoding
    //   if (previous?.decodedQRData != next.decodedQRData &&
    //       next.decodedQRData != null) {
    //     if (mounted && isProcessing) {
    //       final accountNumber = _extractAccountNumber(next.decodedQRData!);

    //       if (accountNumber != null &&
    //           accountNumber.isNotEmpty &&
    //           _isValidAccountNumber(accountNumber)) {
    //         setState(() {
    //           isProcessing = false;
    //         });

    //         context.pushNamed(
    //           'addTransferMoney',
    //           pathParameters: {'acno': accountNumber},
    //         );
    //       } else {
    //         setState(() {
    //           isProcessing = false;
    //         });
    //         showCustomSnackBar(
    //           context,
    //           'QR Code ບໍ່ມີຂໍ້ມູນເລກບັນຊີທີ່ຖືກຕ້ອງ',
    //         );
    //       }
    //     }
    //   }

    //   // Handle errors
    //   if (previous?.errorMessage != next.errorMessage &&
    //       next.errorMessage != null) {
    //     if (mounted && isProcessing) {
    //       setState(() {
    //         isProcessing = false;
    //       });
    //       showCustomSnackBar(context, next.errorMessage!);
    //     }
    //   }
    // });

    return Scaffold(
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
            onPressed: () => cameraController.toggleTorch(),
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
            onPressed: () => cameraController.switchCamera(),
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
                      border: Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                // Loading overlay
                if (isProcessing || qrState.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'ກຳລັງປະມວນຜົນ QR Code...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
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
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'ຈັດ QR Code ໃຫ້ຢູ່ໃນກອບສີຂຽວເພື່ອສະແກນ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                // if (qrState.errorMessage != null)
                //   Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color: Colors.red.shade50,
                //       border: Border.all(color: Colors.red.shade200),
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(Icons.error_outline, color: Colors.red.shade600),
                //         const SizedBox(width: 8),
                //         Expanded(
                //           child: Text(
                //             qrState.errorMessage!,
                //             style: TextStyle(color: Colors.red.shade700),
                //           ),
                //         ),
                //         TextButton(
                //           onPressed: () {
                //             ref.read(qrNotifierProvider.notifier).clearError();
                //             setState(() {
                //               isProcessing = false;
                //             });
                //           },
                //           child: const Text('ລອງໃໝ່'),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
