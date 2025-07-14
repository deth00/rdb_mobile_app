import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/cardinfo.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: 'ບັນຊີເງິນຝາກ'),
      body: Expanded(
        flex: 5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(fixedSize * 0.01),
                child: Container(
                  height: fixedSize * 0.1,
                  width: fixedSize * 0.2,
                  decoration: BoxDecoration(
                    gradient: AppColors.main,
                    borderRadius: BorderRadius.circular(fixedSize * 0.01),
                  ),
                  child: Icon(
                    Icons.account_box,
                    color: Colors.white,
                    size: fixedSize * 0.1,
                  ),
                ),
              ),
              CardInfo(
                title: 'ຊື່ບັນຊີ ',
                text: 'ບັນຊີເງິນຝາກ',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ເລກບັນຊີເງິນຝາກ ',
                text: '123456789',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ເລກບັນຊີເງິກູ້ ',
                text: 'ບັນຊີເງິນກູ້',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ເລກທີສັນຍາ ',
                text: 'Loan 123456789',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ວັນທີປ່ອຍກູ້ ',
                text: '10/2/2023',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ວັນທີ່ໝົດສັນຍາ ',
                text: '10/2/2024',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ໄລຍະກູ້ຢືມ ',
                text: 'ໄລຍະຍາວ (7ປີ)',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ວົງເງິນກູ້ຢືມ ',
                text: '100,000,000 ກີບ',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ຕົ້ນທຶນທີ່ຊຳລະແລ້ວ ',
                text: '70,000,000 ກີບ',
                style: TextStyle(
                  fontSize: fixedSize * 0.01,
                  color: Colors.black54,
                ),
              ),
              CardInfo(
                title: 'ຍອດໜີ້ ',
                text: NumberFormat.currency(
                  locale: 'lo',
                  customPattern: '#,### \u00a4',
                  symbol: 'ກີບ',
                  decimalDigits: 2,
                ).format(1112331212),
                style: TextStyle(fontSize: fixedSize * 0.01, color: Colors.red),
              ),
              CardInfo(
                title: 'ດອກເບ້ຍຄ້າງ ',
                text: NumberFormat.currency(
                  locale: 'lo',
                  customPattern: '#,### \u00a4',
                  symbol: 'ກີບ',
                  decimalDigits: 2,
                ).format(21321321321),
                style: TextStyle(fontSize: fixedSize * 0.01, color: Colors.red),
              ),
              // CardInfo(
              //   title: 'ຊັ້ນໜີ້ ',
              //   text: 'A',
              //   style: TextStyle(
              //     fontSize: fixedSize * 0.01,
              //     color: Colors.green,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
