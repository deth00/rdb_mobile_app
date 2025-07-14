import 'package:flutter/material.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';

class DetailTransferMoneyScreen extends StatelessWidget {
  const DetailTransferMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(AppImage.logoRDB, height: 80),
                    const SizedBox(height: 8),
                    const Text(
                      'ທະນາຄານ ພັດທະນາ ຊົນນະບົດ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Roral Development Bank',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    Icon(
                      Icons.check_circle,
                      color: AppColors.color1,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '15 FEB 2024 10:02 AM',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ເລກທີ່ອ້າງອີງ: 4026XRJ7656',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    _buildAccountInfo(
                      logo: AppImage.logoRDB,
                      bankName: 'ທະນາຄານ ພັດທະນາ ຊົນນະບົດ',
                      accountName: 'PHONGSAVANH BOUBPHACHANH MR',
                      accountNumber: 'LAK 2211-XXXX-XXXX-5001',
                    ),
                    const SizedBox(height: 16),
                    _buildAccountInfo(
                      logo: AppImage.iconW,
                      bankName: 'ທະນາຄານ ພັດທະນາລາວ',
                      accountName: 'PHONGSAVANH BOUBPHACHANH MR',
                      accountNumber: 'LAK 2211-XXXX-XXXX-5001',
                    ),
                    const SizedBox(height: 20),
                    _buildTransactionDetailRow(
                      'ຈຳນວນເງິນ',
                      '-10,000,000.00 Kip',
                    ),
                    const SizedBox(height: 8),
                    _buildTransactionDetailRow('ຄ່າທຳນຽມ', '-1,000.00 Kip'),
                    const SizedBox(height: 8),
                    _buildTransactionDetailRow(
                      'ລາຍລະອຽດ',
                      'ໂອນເງິນຄ່າສິນຄ້າ',
                      valueColor: Colors.black,
                    ),
                    const SizedBox(height: 20),
                    Image.asset(AppImage.qr, width: 150, height: 150),
                    const SizedBox(height: 8),
                    const Text('ສະແກນເພື່ອເບິ່ງລາຍລະອຽດການຊຳລະ'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(
                          Icons.file_download_outlined,
                          'ບັນທຶກ',
                        ),
                        const SizedBox(width: 40),
                        _buildActionButton(Icons.share_outlined, 'ແບ່ງປັນ'),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.color1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ສຳເລັດ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.color1, size: 30),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  Widget _buildTransactionDetailRow(
    String label,
    String value, {
    Color? valueColor = Colors.red,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfo({
    required String logo,
    required String bankName,
    required String accountName,
    required String accountNumber,
  }) {
    return Row(
      children: [
        Image.asset(logo, height: 40),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bankName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Text(accountName, style: const TextStyle(fontSize: 14)),
            Text(accountNumber, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
