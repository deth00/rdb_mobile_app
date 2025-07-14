import 'package:flutter/material.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/deposit/presentation/detali_transfer_money.dart';

class ConfirmTransferMoneyScreen extends StatefulWidget {
  const ConfirmTransferMoneyScreen({super.key});

  @override
  State<ConfirmTransferMoneyScreen> createState() =>
      _ConfirmTransferMoneyScreenState();
}

class _ConfirmTransferMoneyScreenState
    extends State<ConfirmTransferMoneyScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            AppImage.back,
            height: 24,
            width: 24,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'ປ້ອນລະຫັດ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to home or first screen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Row(
              children: [
                Icon(Icons.close, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'ຍົກເລີກ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: AppColors.color1,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'ລະຫັດ'),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextFormField(
              obscureText: _obscureText,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'ໃສ່ລະຫັດ',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: AppColors.color1.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: AppColors.color1.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.color1, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Image.asset(
                    AppImage.show,
                    height: 24,
                    width: 24,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  Image.asset(AppImage.finger, height: 80, width: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'ຢືນຢັນດ້ວຍລາຍນິ້ວມື',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailTransferMoneyScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.color1,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ຕໍ່ໄປ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
