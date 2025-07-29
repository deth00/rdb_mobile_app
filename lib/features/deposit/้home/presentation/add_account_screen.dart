import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/snackbar_helper.dart';
import 'package:moblie_banking/features/deposit/้home/logic/dpt_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

import '../../../../core/utils/app_colors.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  final TextEditingController _accountController = TextEditingController();

  Future<void> submit() async {
    final acno = _accountController.text.trim();

    if (acno.isEmpty) {
      showCustomSnackBar(context, 'ກະລຸນາໃສ່ເລກບັນຊີຂອງທ່ານ', isError: true);
      return;
    }

    await ref.read(dptNotifierProvider.notifier).addAcno(acno);
    final dptstate = ref.read(dptNotifierProvider);

    if (!mounted) return;

    if (!dptstate.isLoading && dptstate.errorMessage == null) {
      // ✅ Show dialog success
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('ເພິ່ມບັນຊິສຳເລັດ'),
            ],
          ),
          content: const Text('ເພິ່ມບັນຊິສຳເລັດ'),
        ),
      );

      // ✅ Auto close dialog & go to home after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop(); // ปิด Dialog
          context.goNamed('home'); // กลับไปหน้า home
        }
      });
    } else if (dptstate.errorMessage != null) {
      showCustomSnackBar(context, dptstate.errorMessage!, isError: true);
    }
  }

  @override
  void dispose() {
    _accountController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dptNotifierProvider);
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;

    return Scaffold(
      appBar: GradientAppBar(title: 'ເພິ່ມບັນຊິ'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              'ກະລຸນາປ້ອນເລກບັນຊີຂອງທ່ານ',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextField(
              controller: _accountController,
              enabled: !state.isLoading,
              decoration: InputDecoration(
                hintText: '0201 111 XXXXXXXXXX',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Color(0xFF2CA58D)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Color(0xFF2CA58D)),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            // Show loading indicator
            if (state.isLoading) ...[
              SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('ກຳລັງເພີ່ມບັນຊີ...'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.main),
            child: FloatingActionButton.extended(
              onPressed: state.isLoading
                  ? null
                  : () {
                      submit();
                    },
              label: Center(
                child: state.isLoading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'ກຳລັງສົ່ງ...',
                            style: TextStyle(
                              fontSize: fixedSize * 0.015,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'ຕໍ່ໄປ',
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
}
