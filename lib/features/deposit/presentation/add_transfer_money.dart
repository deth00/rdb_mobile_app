import 'package:flutter/material.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/deposit/presentation/confirm_transfer_money.dart';

class AddTransferMoney extends StatefulWidget {
  const AddTransferMoney({super.key});

  @override
  State<AddTransferMoney> createState() => _AddTransferMoneyState();
}

class _AddTransferMoneyState extends State<AddTransferMoney> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fixedSize = size.width + size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, fixedSize),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(fixedSize * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(fixedSize * 0.02),
                  topRight: Radius.circular(fixedSize * 0.02),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAccountInfo(
                    fixedSize,
                    title: 'ຕົ້ນທາງ',
                    icon: AppImage.logoRDB,
                    bankName: 'ທະນາຄານ ພັດທະນາ ຊົນນະບົດ',
                    accountHolder: 'PHONGSAVANH BOUBPHACHANH MR',
                    accountNumber: 'LAK 2211-XXXX-XXXX-5001',
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildAccountInfo(
                    fixedSize,
                    title: 'ປາຍທາງ',
                    icon: AppImage.cop,
                    bankName: 'ທະນາຄານ ພັດທະນາລາວ',
                    accountHolder: 'PHONGSAVANH BOUBPHACHANH MR',
                    accountNumber: 'LAK 2211-XXXX-XXXX-5001',
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  Text(
                    'ວົງເງິນໂອນສູງສຸດ 150.000.000,00 LAK',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: fixedSize * 0.01,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: fixedSize * 0.01),
                  _buildAmountField(fixedSize),
                  SizedBox(height: fixedSize * 0.01),
                  _buildDetailsField(fixedSize),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildContinueButton(context, fixedSize),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, double fixedSize) {
    return AppBar(
      backgroundColor: AppColors.color1,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: fixedSize * 0.01),
          Text(
            'ໂອນເງິນ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fixedSize * 0.015,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.close, color: Colors.white),
              Text(
                'ຍົກເລີກ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fixedSize * 0.008,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: fixedSize * 0.01),
      ],
      centerTitle: true,
    );
  }

  Widget _buildAccountInfo(
    double fixedSize, {
    required String title,
    required String icon,
    required String bankName,
    required String accountHolder,
    required String accountNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: fixedSize * 0.014,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: AssetImage(icon),
            radius: fixedSize * 0.02,
          ),
          title: Text(
            bankName,
            style: TextStyle(
              color: Colors.black,
              fontSize: fixedSize * 0.011,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                accountHolder,
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black87,
                ),
              ),
              Text(
                accountNumber,
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildAmountField(double fixedSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'ຈຳນວນເງິນ ',
            style: TextStyle(
              fontSize: fixedSize * 0.012,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: fixedSize * 0.005),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'ປ້ອນຈຳນວນເງິນ',
                  hintStyle: TextStyle(
                    fontSize: fixedSize * 0.012,
                    color: Colors.grey[400],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fixedSize * 0.01),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fixedSize * 0.01),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fixedSize * 0.01),
                    borderSide: BorderSide(color: AppColors.color1),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: fixedSize * 0.01,
                    vertical: fixedSize * 0.01,
                  ),
                ),
              ),
            ),
            SizedBox(width: fixedSize * 0.005),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: fixedSize * 0.015,
                vertical: fixedSize * 0.012,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(fixedSize * 0.01),
              ),
              child: Text(
                '.00',
                style: TextStyle(
                  fontSize: fixedSize * 0.012,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsField(double fixedSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'ລາຍລະອຽດ ',
            style: TextStyle(
              fontSize: fixedSize * 0.012,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            children: const <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: fixedSize * 0.005),
        TextField(
          controller: _detailsController,
          decoration: InputDecoration(
            hintText: 'ລາຍລະອຽດ',
            hintStyle: TextStyle(
              fontSize: fixedSize * 0.012,
              color: Colors.grey[400],
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(fixedSize * 0.008),
              child: Image.asset(AppImage.feedback, width: fixedSize * 0.01),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fixedSize * 0.01),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fixedSize * 0.01),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fixedSize * 0.01),
              borderSide: BorderSide(color: AppColors.color1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: fixedSize * 0.01,
              vertical: fixedSize * 0.01,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, double fixedSize) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConfirmTransferMoneyScreen(),
          ),
        );
      },
      child: Container(
        height: fixedSize * 0.06,
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: fixedSize * 0.02,
          vertical: fixedSize * 0.01,
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.color1,
            borderRadius: BorderRadius.circular(fixedSize * 0.03),
          ),
          child: Row(
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
    );
  }
}
