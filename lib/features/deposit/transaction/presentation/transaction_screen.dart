import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/app_image.dart';
import 'package:moblie_banking/features/deposit/transaction/logic/transaction_provider.dart';
import 'package:moblie_banking/core/models/transaction_model.dart';
import 'package:moblie_banking/widgets/appbar.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load first batch
    Future.microtask(() {
      ref.read(transactionNotifierProvider.notifier).fetchTransactions();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(transactionNotifierProvider.notifier).fetchTransactions();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(String input) {
    try {
      final date = DateFormat("dd/MM/yyyy HH:mm").parse(input);
      return DateFormat('MM/yyyy').format(date);
    } catch (_) {
      return input;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionNotifierProvider);
    final transactionList = state.transactions;

    Size size = MediaQuery.of(context).size;
    double fixedSize = size.width + size.height;

    return Scaffold(
      appBar: GradientAppBar(title: 'ການເຄື່ອນໄຫວ', isLogout: true),
      body: state.isLoading && transactionList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('ກຳລັງໂຫຼດຂໍ້ມູນ...'),
                ],
              ),
            )
          : state.error != null && transactionList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(transactionNotifierProvider.notifier)
                          .clearError();
                      ref
                          .read(transactionNotifierProvider.notifier)
                          .fetchTransactions();
                    },
                    child: Text('ລອງໃໝ່'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(transactionNotifierProvider.notifier)
                    .refreshTransactions();
              },
              child: GroupedListView<dynamic, String>(
                controller: _scrollController,
                elements: transactionList,
                groupBy: (tx) => formatDate(tx.valuedt),
                groupComparator: (a, b) {
                  DateTime parseMonth(String monthYear) =>
                      DateFormat('MM/yyyy').parse(monthYear);
                  return parseMonth(b).compareTo(parseMonth(a));
                },
                itemComparator: (a, b) => b.valuedt.compareTo(a.valuedt),
                useStickyGroupSeparators: true,
                floatingHeader: true,
                groupSeparatorBuilder: (String groupByValue) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: fixedSize * 0.008,
                    vertical: fixedSize * 0.004,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: fixedSize * 0.01),
                    alignment: Alignment.centerRight,
                    height: fixedSize * 0.025,
                    decoration: BoxDecoration(
                      gradient: AppColors.main,
                      borderRadius: BorderRadius.circular(fixedSize * 0.005),
                    ),
                    child: Text(
                      groupByValue,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fixedSize * 0.011,
                      ),
                    ),
                  ),
                ),
                itemBuilder: (context, tx) {
                  final isIncome = tx.amt >= 0;
                  final icon = isIncome ? Icons.call_received : Icons.call_made;
                  final iconColor = isIncome ? Colors.green : Colors.red;
                  final title = isIncome ? 'ໄດ້ຮັບເງິນ' : 'ໂອນເງິນອອກ';
                  // final bgColor = Colors.grey[100];

                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(
                      horizontal: fixedSize * 0.008,
                      vertical: fixedSize * 0.0005,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(fixedSize * 0.01),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: iconColor.withOpacity(0.1),
                            child: Icon(icon, color: iconColor),
                          ),
                          SizedBox(width: fixedSize * 0.015),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tx.txcode == 'DPT_CFM'
                                          ? 'ຄ່າທຳນຽມ'
                                          : title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fixedSize * 0.013,
                                      ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'en_US',
                                        symbol: 'ກີບ',
                                        decimalDigits: 2,
                                        customPattern: '#,##0.00 ¤',
                                      ).format(tx.amt),
                                      style: TextStyle(
                                        color: iconColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fixedSize * 0.013,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  'ເລກອ້າງອີງ: ${tx.txrefid}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: fixedSize * 0.010,
                                  ),
                                ),

                                Text(
                                  'ຫາບັນຊີ: ${tx.usrname}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: fixedSize * 0.010,
                                  ),
                                ),
                                Text(
                                  'ລາຍລະອຽດ: ${tx.descr}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: fixedSize * 0.009,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(
                                    DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).parse(tx.valuedt),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: fixedSize * 0.009,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: state.isLoading && transactionList.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(fixedSize * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: fixedSize * 0.01),
                  Text(
                    'ກຳລັງໂຫຼດຂໍ້ມູນເພີ່ມ...',
                    style: TextStyle(fontSize: fixedSize * 0.012),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
