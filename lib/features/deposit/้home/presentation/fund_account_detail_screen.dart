import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/deposit/้home/logic/fund_account_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class FundAccountDetailScreen extends ConsumerStatefulWidget {
  final String acno;

  const FundAccountDetailScreen({super.key, required this.acno});

  @override
  ConsumerState<FundAccountDetailScreen> createState() =>
      _FundAccountDetailScreenState();
}

class _FundAccountDetailScreenState
    extends ConsumerState<FundAccountDetailScreen> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(fundAccountNotifierProvider.notifier)
          .getFundAccountDetail(widget.acno);
    });
  }

  /// ບໍ່ໃຫ້ເຫັນໂຕເລກບາງສ່ວນ
  String _maskAccount(String acNo) {
    if (acNo.length < 10) return 'xxxx';
    return '${acNo.substring(0, 3)} xxxx xxxx ${acNo.substring(acNo.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    final fundAccountState = ref.watch(fundAccountNotifierProvider);

    return Scaffold(
      appBar: GradientAppBar(title: 'ລາຍລະອຽດບັນຊີ', isLogout: false),
      body: SafeArea(
        child: fundAccountState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : fundAccountState.errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 64),
                    SizedBox(height: fixedSize * 0.01),
                    Text(
                      fundAccountState.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: fixedSize * 0.01),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(fundAccountNotifierProvider.notifier)
                            .clearError();
                        ref
                            .read(fundAccountNotifierProvider.notifier)
                            .getFundAccountDetail(widget.acno);
                      },
                      child: Text('ລອງໃໝ່'),
                    ),
                  ],
                ),
              )
            : fundAccountState.fundAccountDetail != null
            ? SingleChildScrollView(
                padding: EdgeInsets.all(fixedSize * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAccountCard(
                      fundAccountState.fundAccountDetail!,
                      fixedSize,
                    ),
                    SizedBox(height: fixedSize * 0.02),
                    _buildDetailsCard(
                      fundAccountState.fundAccountDetail!,
                      fixedSize,
                    ),
                    SizedBox(height: fixedSize * 0.02),
                    _buildContactCard(
                      fundAccountState.fundAccountDetail!,
                      fixedSize,
                    ),
                  ],
                ),
              )
            : Center(child: Text('ບໍ່ມີຂໍ້ມູນບັນຊີ')),
      ),
    );
  }

  Widget _buildAccountCard(dynamic fundAccount, double fixedSize) {
    final currencyFormat = NumberFormat.currency(locale: 'lo_LA', symbol: '₭');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(fixedSize * 0.02),
      decoration: BoxDecoration(
        gradient: AppColors.main,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ບັນຊີເງິນຝາກ',
            style: TextStyle(
              color: Colors.white,
              fontSize: fixedSize * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: fixedSize * 0.01),
          Text(
            fundAccount.acName,
            style: TextStyle(
              color: Colors.white,
              fontSize: fixedSize * 0.016,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: fixedSize * 0.005),
          // 🔒 ເລກບັນຊີ with show/hide functionality
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isVisible ? fundAccount.acNo : _maskAccount(fundAccount.acNo),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: fixedSize * 0.014,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: Container(
                  height: fixedSize * 0.02,
                  width: fixedSize * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(fixedSize * 0.007),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      isVisible ? 'ປິດ' : 'ສະແດງ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fixedSize * 0.012,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: fixedSize * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ຍອດເງິນ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: fixedSize * 0.013,
                    ),
                  ),
                  Row(
                    children: [
                      // Image.asset(
                      //   AppImage.kip,
                      //   scale: fixedSize * 0.03,
                      //   color: Colors.white,
                      // ),
                      SizedBox(width: fixedSize * 0.005),
                      Text(
                        isVisible
                            ? currencyFormat.format(fundAccount.balance)
                            : 'xxxxx',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fixedSize * 0.020,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ດອກເບ້ຍ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: fixedSize * 0.013,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Image.asset(
                      //   AppImage.kip,
                      //   scale: fixedSize * 0.03,
                      //   color: Colors.white,
                      // ),
                      SizedBox(width: fixedSize * 0.005),
                      Text(
                        isVisible
                            ? currencyFormat.format(fundAccount.intpbl)
                            : 'xxxxx',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fixedSize * 0.016,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(dynamic fundAccount, double fixedSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(fixedSize * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ລາຍລະອຽດບັນຊີ',
            style: TextStyle(
              fontSize: fixedSize * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: fixedSize * 0.015),
          _buildDetailRow('ປະເພດບັນຊີ', fundAccount.catname, fixedSize),
          SizedBox(height: fixedSize * 0.01),
          _buildDetailRow(
            'ຍອດເງິນຕ່ຳສຸດ',
            '${fundAccount.minAmt} ₭',
            fixedSize,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(dynamic fundAccount, double fixedSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(fixedSize * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ຂໍ້ມູນຕິດຕໍ່',
            style: TextStyle(
              fontSize: fixedSize * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: fixedSize * 0.015),
          if (fundAccount.mphone.hp.isNotEmpty)
            _buildDetailRow('ເບີໂທລະສັບ', fundAccount.mphone.hp, fixedSize),
          if (fundAccount.mphone.hp.isNotEmpty)
            SizedBox(height: fixedSize * 0.01),
          if (fundAccount.mphone.fp.isNotEmpty)
            _buildDetailRow('ເບີແຟັກ', fundAccount.mphone.fp, fixedSize),
          if (fundAccount.mphone.fp.isNotEmpty)
            SizedBox(height: fixedSize * 0.01),
          if (fundAccount.mphone.cp.isNotEmpty)
            _buildDetailRow('ເບີມືຖື', fundAccount.mphone.cp, fixedSize),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double fixedSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: fixedSize * 0.08,
          child: Text(
            label,
            style: TextStyle(
              fontSize: fixedSize * 0.014,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: fixedSize * 0.014,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
