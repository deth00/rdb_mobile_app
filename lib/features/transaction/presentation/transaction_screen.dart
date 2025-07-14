import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/widgets/header.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;
    List _elements = [
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-01 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-01 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-02 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-02 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-03 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-03 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-04 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-04 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-05 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-05 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-06 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-06 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-07 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-07 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-08 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-08 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
      {
        "txrefid": "123456789",
        "usrname": "User1",
        "valuedt": '2023-10-09 12:00:00',
        "amt": 1500000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "send",
      },
      {
        "txrefid": "987654321",
        "usrname": "User2",
        "valuedt": '2023-10-09 12:00:00',
        "amt": 2000000,
        "descr": "ຊຳລະບິນໄຟ",
        "type": "receive",
      },
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(title: 'ການເຄື່ອນໄຫວ'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GroupedListView<dynamic, String>(
                elements: _elements,
                groupBy: (elements) =>
                    elements['valuedt'], // Group by date only
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) =>
                    item1['valuedt'].compareTo(item2['valuedt']),
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: EdgeInsets.only(
                    left: fixedSize * 0.006,
                    right: fixedSize * 0.006,
                    top: fixedSize * 0.006,
                    // bottom: fixedSize * 0.0001,
                  ),
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: fixedSize * 0.02,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.main,
                      borderRadius: BorderRadius.all(
                        Radius.circular(fixedSize * 0.005),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: fixedSize * 0.01),
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fixedSize * 0.01,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                itemBuilder: (c, element) {
                  return SizedBox(
                    height: fixedSize * 0.1,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: fixedSize * 0.009,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: fixedSize * 0.08,
                            width: double.infinity,
                            // color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                    AppImage.profile,
                                    scale: 1.3,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: fixedSize * 0.008,
                                    right: fixedSize * 0.001,
                                  ),
                                  child: SizedBox(
                                    height: double.infinity,
                                    width: fixedSize * 0.23,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              element['type'] == 'send'
                                                  ? 'ຊຳລະ'
                                                  : 'ຮັບເງິນ',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: fixedSize * 0.013,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                locale: 'lo',
                                                customPattern: '#,### \u00a4',
                                                symbol: 'ກີບ',
                                                decimalDigits: 2,
                                              ).format(
                                                element['type'] == 'send'
                                                    ? -element['amt']
                                                    : element['amt'],
                                              ),
                                              style: TextStyle(
                                                fontSize: fixedSize * 0.013,
                                                color: element['type'] == 'send'
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                            // Text(data.groupTest[ind]['message']['amt'])
                                          ],
                                        ),
                                        Text(
                                          'ເລກທີບັນຊີ: ${element['txrefid']}',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: fixedSize * 0.01,
                                          ),
                                        ),
                                        Text(
                                          'ຫາບັນຊີ: ${element['usrname']}',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: fixedSize * 0.01,
                                          ),
                                        ),
                                        Text(
                                          'ລາຍລະອຽດ: ${element['descr']}',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: fixedSize * 0.01,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        // Text('${element.valuedt}',
                                        //     style: TextStyle(
                                        //       fontSize: Dimensions.font14,
                                        //     )),
                                        // Text(data.historyList[index].valuedt),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: fixedSize * 0.01,
                            ),
                            child: const Divider(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
