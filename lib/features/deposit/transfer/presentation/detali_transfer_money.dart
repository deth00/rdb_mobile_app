import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';

class DetailTransferMoneyScreen extends StatelessWidget {
  const DetailTransferMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AppImage.logoRDB, width: 80.w),
                Column(
                  children: [
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
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Stack(
                children: [
                  SvgPicture.asset(AppImage.bill, width: 385.w),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 25.h),
                        Icon(
                          Icons.check_circle,
                          color: AppColors.color1,
                          size: 100.w,
                        ),
                        Text(
                          '15 FEB 2024 10:02 AM',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'ເລກທີ່ອ້າງອີງ: 4026XRJ7656',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _buildAccountInfo(
                          logo: AppImage.logoRDB,
                          bankName: 'ທະນາຄານ ພັດທະນາ ຊົນນະບົດ',
                          accountName: 'PHONGSAVANH BOUBPHACHANH MR',
                          accountNumber: 'LAK 2211-XXXX-XXXX-5001',
                        ),
                        SizedBox(height: 10.h),
                        _buildAccountInfo(
                          logo: AppImage.iconW,
                          bankName: 'ທະນາຄານ ພັດທະນາລາວ',
                          accountName: 'PHONGSAVANH BOUBPHACHANH MR',
                          accountNumber: 'LAK 2211-XXXX-XXXX-5001',
                        ),
                        SizedBox(height: 10.h),
                        _buildTransactionDetailRow(
                          'ຈຳນວນເງິນ',
                          '-10,000,000.00 Kip',
                        ),
                        SizedBox(height: 5.h),
                        _buildTransactionDetailRow('ຄ່າທຳນຽມ', '-1,000.00 Kip'),
                        SizedBox(height: 5.h),
                        _buildTransactionDetailRow(
                          'ລາຍລະອຽດ',
                          'ໂອນເງິນຄ່າສິນຄ້າ',
                          valueColor: Colors.black,
                        ),
                        SizedBox(height: 10.h),
                        SvgPicture.asset(AppImage.qr, width: 130.w),
                        SizedBox(height: 5.h),
                        Text(
                          'ສະແກນເພື່ອເບິ່ງລາຍລະອຽດການຊຳລະ',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionButton(Icons.file_download_outlined, 'ບັນທຶກ'),
                  SizedBox(width: 40.w),
                  _buildActionButton(Icons.share_outlined, 'ແບ່ງປັນ'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.color1,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ສຳເລັດ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30.w),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildTransactionDetailRow(
    String label,
    String value, {
    Color? valueColor = Colors.red,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
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
        SvgPicture.asset(logo, width: 40.w),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bankName,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(accountName, style: TextStyle(fontSize: 14.sp)),
            Text(accountNumber, style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ],
    );
  }
}
