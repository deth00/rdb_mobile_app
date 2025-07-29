import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/deposit/transfer/logic/transfer_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class TransferMoney extends ConsumerStatefulWidget {
  const TransferMoney({super.key});

  @override
  ConsumerState<TransferMoney> createState() => _TransferMoneyState();
}

class _TransferMoneyState extends ConsumerState<TransferMoney> {
  final _accountController = TextEditingController();

  Future<void> _checkAccountExist() async {
    final acno = _accountController.text.trim();
    if (acno.isEmpty) {
      showCustomSnackBar(context, 'ກະລຸນາປ້ອນເລກບັນຊີ', isError: true);
      return;
    }

    await ref.read(transferNotifierProvider.notifier).getAccountDetail(acno);
    final state = ref.read(transferNotifierProvider);

    if (state.errorMessage != null) {
      showCustomSnackBar(context, state.errorMessage!, isError: true);
    } else if (state.receiverAccount != null) {
      if (mounted) {
        context.pushNamed(
          'addTransferMoney',
          pathParameters: {'acno': _accountController.text.trim()},
        );
      }
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final transferState = ref.watch(transferNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3FADE),
      appBar: GradientAppBar(title: 'ປ້ອນເລກບັນຊີ'),
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
                  fontWeight: FontWeight.w300,
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
                keyboardType: TextInputType.number,
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
                    child: SvgPicture.asset('assets/icons/inp.svg'),
                  ),
                ),
              ),
            ),
            SizedBox(height: fixedSize * 0.01),
            GestureDetector(
              onTap: transferState.isLoading
                  ? null
                  : () {
                      _checkAccountExist();
                    },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: fixedSize * 0.035,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: transferState.isLoading
                        ? Colors.grey.withOpacity(0.4)
                        : AppColors.color1.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(fixedSize * 0.005),
                  ),
                  child: transferState.isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: fixedSize * 0.015,
                              height: fixedSize * 0.015,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.color1,
                                ),
                              ),
                            ),
                            SizedBox(width: fixedSize * 0.005),
                            Expanded(
                              child: Text(
                                'ກຳລັງກວດສອບ...',
                                style: TextStyle(
                                  fontSize: fixedSize * 0.012,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ຕໍ່ໄປ',
                              style: TextStyle(
                                fontSize: fixedSize * 0.014,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
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
                  itemCount: 0,
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
                            child: Image.asset(AppImage.logoRDB),
                          ),
                        ),
                        title: Text(
                          '',
                          style: TextStyle(
                            fontSize: fixedSize * 0.01,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '',
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
    _showSuccessDialog();
  }

  void _handleTransferFailure() {
    _showErrorDialog('ການຢືນຢັນຕົວຕົນລົ້ມເຫລວ. ກະລຸນາລອງໃໝ່ອີກຄັ້ງ.');
  }

  void _handleTransferWithoutBiometric() {
    _showSuccessDialog();
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
}
