import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/deposit/presentation/add_transfer_money.dart';

class TransferMoney extends ConsumerStatefulWidget {
  const TransferMoney({super.key});

  @override
  ConsumerState<TransferMoney> createState() => _TransferMoneyState();
}

class _TransferMoneyState extends ConsumerState<TransferMoney> {
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;

    final List<Map<String, String>> recentPayees = [
      {
        "name": "PHONGSAVANH BOUBPHACHANH MR",
        "acc": "LAK 2211-XXXX-XXXX-5001",
        "logo": "assets/icons/logo.png",
      },
      {
        "name": "XAYYADETH PHOUTTHARATH MR",
        "acc": "LAK 2211-XXXX-XXXX-6001",
        "logo": "assets/icons/logo.png",
      },
      {
        "name": "XAYYADETH PHOUTTHARATH MR",
        "acc": "LAK 2211-XXXX-XXXX-6001",
        "logo": "assets/icons/cop.png",
      },
      {
        "name": "XAYYADETH PHOUTTHARATH MR",
        "acc": "LAK 2211-XXXX-XXXX-6001",
        "logo": "assets/icons/other.png",
      },
      {
        "name": "XAYYADETH PHOUTTHARATH MR",
        "acc": "LAK 2211-XXXX-XXXX-6001",
        "logo": "assets/icons/logo.png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3FADE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppColors.color1,
        title: Text(
          'ໂອນເງິນ',
          style: TextStyle(
            color: Colors.white,
            fontSize: fixedSize * 0.016,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                fixedSize * 0.01,
                fixedSize * 0.01,
                fixedSize * 0.01,
                fixedSize * 0.005,
              ),
              child: Text(
                'ປ້ອນເລກບັນຊີ, ເລກບັດ ຫຼື ເບີໂທ (ປາຍທາງ)*',
                style: TextStyle(
                  fontSize: fixedSize * 0.011,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              height: fixedSize * 0.04,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: fixedSize * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(fixedSize * 0.01),
                border: Border.all(color: AppColors.color1),
              ),
              child: TextField(
                controller: _accountController,
                decoration: InputDecoration(
                  hintText: 'ເລກບັນຊີ / ເບີໂທ',
                  hintStyle: TextStyle(
                    fontSize: fixedSize * 0.012,
                    color: Colors.grey[600],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: fixedSize * 0.015,
                    vertical: fixedSize * 0.01,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(fixedSize * 0.007),
                    child: Image.asset('assets/icons/inp.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: fixedSize * 0.01),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransferMoney(),
                  ),
                );
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: fixedSize * 0.035,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: AppColors.color1.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(fixedSize * 0.005),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ຕໍ່ໄປ',
                        style: TextStyle(
                          fontSize: fixedSize * 0.014,
                          color: AppColors.color1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.play_arrow,
                        color: AppColors.color1,
                        size: fixedSize * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: fixedSize * 0.02),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: ListView.builder(
                  itemCount: recentPayees.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: fixedSize * 0.01,
                        vertical: fixedSize * 0.002,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: fixedSize * 0.022,
                          backgroundColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset(recentPayees[index]['logo']!),
                          ),
                        ),
                        title: Text(
                          recentPayees[index]['name']!,
                          style: TextStyle(
                            fontSize: fixedSize * 0.01,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          recentPayees[index]['acc']!,
                          style: TextStyle(
                            fontSize: fixedSize * 0.009,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Icon(
                          Icons.thumb_up,
                          color: AppColors.color1,
                          size: fixedSize * 0.02,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Biometric authentication widget
            const SizedBox(height: 16),
            // Alternative transfer button (without biometric)
            ElevatedButton(
              onPressed: _isProcessing ? null : _handleTransferWithoutBiometric,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'ໂອນເງິນ (ບໍ່ຕ້ອງການຢືນຢັນຕົວຕົນ)',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: size.height * 0.08,
        width: double.infinity,
        color: AppColors.color1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(context, 'ຫຼ້າສຸດ', Icons.history, true),
            _buildBottomNavItem(
              context,
              'ຖືກໃຈ',
              Icons.thumb_up_alt_outlined,
              false,
            ),
            _buildBottomNavItem(context, 'ທັງໝົດ', Icons.menu, false),
            _buildBottomNavItem(context, 'ຄົ້ນຫາ', Icons.search, false),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    String label,
    IconData icon,
    bool isActive,
  ) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: fixedSize * 0.025),
        SizedBox(height: fixedSize * 0.001),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: fixedSize * 0.01),
        ),
      ],
    );
  }

  void _handleTransferSuccess() {
    // Simulate transfer processing
    setState(() {
      _isProcessing = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      _showSuccessDialog();
    });
  }

  void _handleTransferFailure() {
    _showErrorDialog('ການຢືນຢັນຕົວຕົນລົ້ມເຫລວ. ກະລຸນາລອງໃໝ່ອີກຄັ້ງ.');
  }

  void _handleTransferWithoutBiometric() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate transfer processing without biometric
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ສຳເລັດ'),
        content: const Text('ການໂອນເງິນສຳເລັດແລ້ວ'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('ຕົກລົງ'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ຂໍ້ຜິດພາດ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('ຕົກລົງ'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    super.dispose();
  }
}
