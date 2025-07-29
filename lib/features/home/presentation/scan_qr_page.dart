import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/home/logic/qr_provider.dart';
import 'package:go_router/go_router.dart';

class ScanQRPage extends ConsumerStatefulWidget {
  const ScanQRPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends ConsumerState<ScanQRPage> {
  bool isProcessing = false;
  MobileScannerController cameraController = MobileScannerController();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (isProcessing) return;

      final String? code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        isProcessing = true;

        await ref.read(qrNotifierProvider.notifier).decodeQR(code);
        final qrState = ref.read(qrNotifierProvider);

        if (qrState.decodedQRData != null) {
          if (mounted) {
            // Extract account number from decoded data
            final accountNumber =
                qrState.decodedQRData?['34']?['03'] ??
                qrState.decodedQRData?['accountNumber'] ??
                qrState.decodedQRData?['acno'];

            if (accountNumber != null) {
              context.goNamed(
                'addTransferMoney',
                pathParameters: {'acno': accountNumber.toString()},
              );
            } else {
              context.goNamed('addTransferMoney', pathParameters: {'acno': ''});
            }
          }
        } else if (qrState.errorMessage != null) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(qrState.errorMessage!)));
          }
          isProcessing = false;
        } else {
          isProcessing = false;
        }
        break; // Process only the first barcode
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
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
                    'Align the QR code within the frame to scan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                if (isProcessing)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Processing QR code...'),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
