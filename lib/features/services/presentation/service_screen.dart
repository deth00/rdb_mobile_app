import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/service_buttom.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: 'ບໍລິການ', isLogout: true),
      body: SafeArea(
        child: Column(
          children: [
            ServiceButtom(
              title: 'ສະຖານທີ່ບໍລິການ',
              text: 'ສາຂາ ແລະ ໜ່ວຍບໍລິການ',
              image: AppImage.location,
              onpress: () => context.push('/location'),
            ),

            ServiceButtom(
              title: 'ຄ່າທຳນຽມ',
              text: 'ຄ່າທຳນຽມບໍລິການຕ່າງໆຂອງ RDB',
              image: AppImage.fees,
              onpress: () {},
            ),

            GestureDetector(
              onTap: () {},
              child: const ServiceButtom(
                title: 'ອັດຕາດອກເບ້ຍ',
                text: 'ດອກເບ້ຍເງິນຝາກ ແລະ ກູ້ຢືມ',
                image: AppImage.rate,
              ),
            ),

            ServiceButtom(
              title: 'ຂ່າວສານ',
              text: 'ເບິ່ງຂໍ້ມູນຂ່າວສານຂອງ ທພບ',
              image: AppImage.news,
              onpress: () {},
            ),
          ],
        ),
      ),
    );
  }
}
