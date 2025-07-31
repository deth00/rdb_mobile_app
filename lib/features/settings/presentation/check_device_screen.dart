import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class CheckDevicePage extends StatelessWidget {
  const CheckDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = [
      {
        'platform': 'android',
        'os': 'Android 11; 2201175sg',
        'build': 'Build/RP1A.024988.002',
        'lastLogin': '24/06/2024 10:09:29',
        'status': 'ອຸປະກອນຂອງທ່ານ',
        'current': true,
      },
      {
        'platform': 'ios',
        'os': 'iOS',
        'build': 'Android 11; 2201175sg\nBuild/RP1A.024988.002',
        'lastLogin': '22/06/2024 09:09:29',
        'status': 'ເປີດໃຊ້ງານບນອຸປະກອນອື່ນ',
        'current': false,
      },
      {
        'platform': 'android',
        'os': 'Android 11; 2201175sg',
        'build': 'MIUI/V12.0.9.0.QGDRTHYE',
        'lastLogin': '22/06/2024 10:09:29',
        'status': 'ເປີດໃຊ້ງານບນອຸປະກອນອື່ນ',
        'current': false,
      },
    ];

    return Scaffold(
      appBar: GradientAppBar(title: 'ຈັດການອຸປະກອນ'),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFe8f5e9),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'ອຸປະກອນທີ່ທ່ານເຄີຍໃຊ້ເຂົ້າລະບົບ, ຖ້າພົບອຸປະກອນທີ່ບໍ່ຮູ້ຈັກຫຼືສົງໄສກະລຸນາແຈ້ງທັນທີ. ຖ້າບໍ່ມີອຸປະກອນໃນລາຍການນີ້, ທ່ານຢູ່ປອດໄພ!',
              style: TextStyle(fontSize: 13.sp, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: devices.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, i) {
                final d = devices[i];
                return ListTile(
                  leading: d['platform'] == 'android'
                      ? Icon(Icons.android, color: Color(0xFF4CB879), size: 48)
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            'iOS',
                            style: TextStyle(
                              fontSize: 36,
                              color: Color(0xFF4CB879),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ),
                  title: Text(
                    (d['os'] ?? '') as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (d['build'] ?? '') as String,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'ເຂົ້າລະບົບລ່າສຸດ ${(d['lastLogin'] ?? '') as String}',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: Color(0xFF4CB879),
                            size: 16,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            (d['status'] ?? '') as String,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: d['current'] == true
                                  ? Color(0xFF4CB879)
                                  : Colors.black54,
                              fontWeight: d['current'] == true
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                backgroundColor: const Color(0xFF4CB879),
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 0,
              ),
              onPressed: () {
                context.pop();
              },
              child: const Text('ບັນທຶກ'),
            ),
          ),
        ],
      ),
    );
  }
}
