import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_image.dart';

class DetailCheckPaymentScreen extends StatelessWidget {
  const DetailCheckPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.color1,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(AppImage.back),
        ),
        title: const Text(
          'ກວດສອບການຊຳລະ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ເລກທີ່ໃບບິນ:', '12345'),
            const SizedBox(height: 16),
            _buildDetailRow('ວັນ/ເດືອນ/ປີ:', '29/04/2025'),
            const SizedBox(height: 16),
            _buildDetailRow(
              'ສະຖານະ:',
              'ສຳເລັດການອະນຸມັດ',
              valueColor: AppColors.color1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.color1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            child: const Text(
              'ຕົກລົງ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 18, color: Colors.black54)),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: valueColor ?? Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
