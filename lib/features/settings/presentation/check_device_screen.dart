import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class CheckDevicePage extends StatefulWidget {
  const CheckDevicePage({super.key});

  @override
  State<CheckDevicePage> createState() => _CheckDevicePageState();
}

class _CheckDevicePageState extends State<CheckDevicePage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic>? currentDeviceInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    try {
      Map<String, dynamic> deviceData = {};

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceData = {
          'platform': 'android',
          'os': 'Android ${androidInfo.version.release}',
          'build': 'Build/${androidInfo.fingerprint}',
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'manufacturer': androidInfo.manufacturer,
          'device': androidInfo.device,
          'product': androidInfo.product,
          'hardware': androidInfo.hardware,
          'lastLogin': _getCurrentDateTime(),
          'status': 'ອຸປະກອນຂອງທ່ານ',
          'current': true,
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceData = {
          'platform': 'ios',
          'os': 'iOS ${iosInfo.systemVersion}',
          'build': 'Build/${iosInfo.utsname.machine}',
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'localizedModel': iosInfo.localizedModel,
          'lastLogin': _getCurrentDateTime(),
          'status': 'ອຸປະກອນຂອງທ່ານ',
          'current': true,
        };
      }

      setState(() {
        currentDeviceInfo = deviceData;
        isLoading = false;
      });
    } catch (e) {
      print('Error getting device info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Create devices list with current device info
    final devices = <Map<String, dynamic>>[];

    if (currentDeviceInfo != null) {
      devices.add(currentDeviceInfo!);
    }

    // Add some sample devices for demonstration
    if (Platform.isAndroid) {
      devices.addAll([
        {
          'platform': 'ios',
          'os': 'iOS 15.0',
          'build': 'Build/iPhone14,2',
          'lastLogin': '22/06/2024 09:09:29',
          'status': 'ເປີດໃຊ້ງານບນອຸປະກອນອື່ນ',
          'current': false,
        },
        {
          'platform': 'android',
          'os': 'Android 12; SM-G998B',
          'build': 'MIUI/V12.0.9.0.QGDRTHYE',
          'lastLogin': '22/06/2024 10:09:29',
          'status': 'ເປີດໃຊ້ງານບນອຸປະກອນອື່ນ',
          'current': false,
        },
      ]);
    } else if (Platform.isIOS) {
      devices.addAll([
        {
          'platform': 'android',
          'os': 'Android 11; 2201175sg',
          'build': 'Build/RP1A.024988.002',
          'lastLogin': '22/06/2024 09:09:29',
          'status': 'ເປີດໃຊ້ງານບນອຸປະກອນອື່ນ',
          'current': false,
        },
        {
          'platform': 'android',
          'os': 'Android 12; SM-G998B',
          'build': 'MIUI/V12.0.9.0.QGDRTHYE',
          'lastLogin': '22/06/2024 10:09:29',
          'status': 'ເປີດໃຊ້ງານບນອຸປະກອນອື່ນ',
          'current': false,
        },
      ]);
    }

    return Scaffold(
      appBar: GradientAppBar(title: 'ຈັດການອຸປະກອນ'),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  Text(
                    'ກຳລັງດຶງຂໍ້ມູນອຸປະກອນ...',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFe8f5e9),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
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
                            ? Icon(
                                Icons.android,
                                color: Color(0xFF4CB879),
                                size: 48,
                              )
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
                            if (d['model'] != null) ...[
                              SizedBox(height: 2.h),
                              Text(
                                'Model: ${d['model']}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                            if (d['brand'] != null) ...[
                              SizedBox(height: 2.h),
                              Text(
                                'Brand: ${d['brand']}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
