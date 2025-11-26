import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/features/deposit/transaction/logic/transaction_provider.dart';
import 'package:moblie_banking/features/deposit/้home/logic/fund_account_provider.dart';
import 'package:moblie_banking/features/home/logic/home_provider.dart';
import 'package:moblie_banking/widgets/appbar.dart';
import 'package:moblie_banking/features/deposit/transaction/presentation/transaction_detail_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/route_constants.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  final String? acno; // Add optional acno parameter
  const TransactionScreen({super.key, this.acno});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _currentAcno;

  @override
  void initState() {
    super.initState();

    // Get account number from multiple sources
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentAccountNumber();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadTransactions();
      }
    });
  }

  void _getCurrentAccountNumber() {
    // Priority order for getting account number:
    // 1. From widget parameter (if passed)
    // 2. From fund account state (current account)
    // 3. From home state (first deposit account)

    String? acno = widget.acno;
    if (acno == null || acno.isEmpty) {
      // Try to get from fund account state
      final fundAccountState = ref.read(fundAccountNotifierProvider);
      acno = fundAccountState.fundAccountDetail?.acNo;
    }
    if (acno == null || acno.isEmpty) {
      // Try to get from home state
      final homeState = ref.read(homeNotifierProvider);
      if (homeState.accountDpt.isNotEmpty) {
        acno = homeState.accountDpt.first.linkValue;
      }
    }

    if (acno != null && acno.isNotEmpty && acno != _currentAcno) {
      _currentAcno = acno;
      // Clear previous transactions when account number changes
      ref.read(transactionNotifierProvider.notifier).clearTransactions();
      _loadTransactions();
      // Load fund account details for this account
      _loadFundAccountDetails();
    }
  }

  void _loadTransactions() {
    if (_currentAcno == null || _currentAcno!.isEmpty) {
      _getCurrentAccountNumber();
      return;
    }

    ref
        .read(transactionNotifierProvider.notifier)
        .fetchTransactions(acno: _currentAcno!);
  }

  void _loadFundAccountDetails() {
    if (_currentAcno == null || _currentAcno!.isEmpty) {
      return;
    }

    // Load fund account details for the current account
    ref
        .read(fundAccountNotifierProvider.notifier)
        .getFundAccountDetail(_currentAcno!);
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

  String _getAccountNumber() {
    if (_currentAcno == null || _currentAcno!.isEmpty) {
      return 'ບໍ່ພົບຂໍ້ມູນບັນຊີ';
    }

    // Format account number with spaces and mask middle digits for privacy
    String accountNumber = _currentAcno!;
    if (accountNumber.length >= 8) {
      // Format: 0201 111 XXXXXXXXX 63
      String prefix = accountNumber.substring(0, 4);
      String middle = accountNumber.substring(4, 7);
      String masked = 'X' * (accountNumber.length - 7);
      String suffix = accountNumber.substring(accountNumber.length - 2);

      return '$prefix $middle $masked $suffix';
    }

    return accountNumber;
  }

  String _getAccountName() {
    // Try to get account name from fund account state first
    final fundAccountState = ref.watch(fundAccountNotifierProvider);
    // print('Fund Account State: ${fundAccountState.fundAccountDetail?.acName}');
    // print('Current Acno: $_currentAcno');

    if (fundAccountState.fundAccountDetail?.acName != null &&
        fundAccountState.fundAccountDetail!.acName.isNotEmpty) {
      return fundAccountState.fundAccountDetail!.acName;
    }

    // Fallback to account number if name is not available
    if (_currentAcno != null && _currentAcno!.isNotEmpty) {
      return _currentAcno!;
    }

    return 'ບໍ່ພົບຂໍ້ມູນບັນຊີ';
  }

  String _getAccountBalance() {
    // Try to get balance from fund account state first
    final fundAccountState = ref.watch(fundAccountNotifierProvider);
    print(
      'Fund Account Balance: ${fundAccountState.fundAccountDetail?.balance}',
    );

    if (fundAccountState.fundAccountDetail?.balance != null) {
      // Format balance with comma separators and "kip" currency
      String formattedBalance = NumberFormat(
        '#,##0',
        'en_US',
      ).format(fundAccountState.fundAccountDetail!.balance.toInt());
      return '$formattedBalance kip';
    }

    // Fallback to home state account balance
    final homeState = ref.read(homeNotifierProvider);
    if (homeState.accountDpt.isNotEmpty) {
      final account = homeState.accountDpt.firstWhere(
        (acc) => acc.linkValue == _currentAcno,
        orElse: () => homeState.accountDpt.first,
      );
      // Note: AccountLinkage doesn't have balance, so we'll show account number
      return account.linkValue;
    }

    return 'ບໍ່ພົບຂໍ້ມູນ';
  }

  Widget _buildAccountInfoRow({
    required String label,
    required String value,
    required bool isLoading,
    required Color colrs,
  }) {
    if (isLoading) {
      return Row(
        children: [
          if (label.isNotEmpty) ...[
            Text(
              '$label: ',
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
            ),
          ],
          SizedBox(
            width: 16.w,
            height: 16.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
            ),
          ),
        ],
      );
    }

    return Text(
      label.isNotEmpty ? '$label $value' : value,
      style: TextStyle(
        fontSize: label.isNotEmpty ? 16.sp : 18.sp,
        color: label.isNotEmpty ? colrs : Colors.green[700],
        fontWeight: label.isNotEmpty ? FontWeight.normal : FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionNotifierProvider);
    final transactionList = state.transactions;

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
          : _currentAcno == null || _currentAcno!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'ບໍ່ພົບຂໍ້ມູນບັນຊີ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      _getCurrentAccountNumber();
                    },
                    child: Text('ລອງໃໝ່', style: TextStyle(fontSize: 16.sp)),
                  ),
                ],
              ),
            )
          : state.error != null && transactionList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(transactionNotifierProvider.notifier)
                          .clearError();
                      _loadTransactions();
                    },
                    child: Text('ລອງໃໝ່', style: TextStyle(fontSize: 16.sp)),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _getCurrentAccountNumber(); // Refresh account number
                if (_currentAcno != null && _currentAcno!.isNotEmpty) {
                  await ref
                      .read(transactionNotifierProvider.notifier)
                      .refreshTransactions(acno: _currentAcno!);
                  // Also refresh fund account details
                  _loadFundAccountDetails();
                }
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.color2.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAccountInfoRow(
                          colrs: Colors.black,
                          label: _getAccountName(),
                          value: '',
                          isLoading: ref
                              .watch(fundAccountNotifierProvider)
                              .isLoading,
                        ),
                        SizedBox(height: 4.h),
                        _buildAccountInfoRow(
                          colrs: Colors.grey[600]!,
                          label: _getAccountNumber(),
                          value: '',
                          isLoading: false,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              'ຍອດເງິນທີ່ນຳໃຊ້ໄດ້: ',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            _buildAccountInfoRow(
                              colrs: Colors.grey,
                              label: '',
                              value: _getAccountBalance(),
                              isLoading: ref
                                  .watch(fundAccountNotifierProvider)
                                  .isLoading,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
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
                      useStickyGroupSeparators: false,
                      floatingHeader: true,
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          alignment: Alignment.centerRight,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.color1.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            groupByValue,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      itemBuilder: (context, tx) {
                        final isIncome = tx.amt >= 0;
                        final icon = isIncome
                            ? Icons.call_received
                            : Icons.call_made;
                        final iconColor = isIncome ? Colors.green : Colors.red;
                        final title = isIncome
                            ? 'ໄດ້ຮັບເງິນ'
                            : tx.txcode == 'DPT_CWR'
                            ? "ຖອນເງິນອອກ"
                            : tx.txcode == 'DPT_DPG'
                            ? 'ໄດ້ຮັບເງິນ'
                            : tx.txcode == 'DPT_TIP'
                            ? "ດອກເບ້ຍເງິນຝາກ"
                            : 'ໂອນເງິນອອກ';
                        // final bgColor = Colors.grey[100];

                        return GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              RouteConstants.transactionDetail,
                              pathParameters: {'acno': _currentAcno ?? ''},
                              queryParameters: {'title': title},
                              extra: tx,
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 2.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 1,
                            child: Padding(
                              padding: EdgeInsets.all(15.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: iconColor.withOpacity(0.1),
                                    child: Icon(icon, color: iconColor),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              tx.txcode == 'DPT_CFM'
                                                  ? 'ຄ່າທຳນຽມ'
                                                  : tx.txcode == 'DPT_CWR'
                                                  ? "ຖອນເງິນອອກ"
                                                  : tx.txcode == 'DPT_DPG'
                                                  ? 'ໄດ້ຮັບເງິນ'
                                                  : tx.txcode == 'DPT_TIP'
                                                  ? "ດອກເບ້ຍເງິນຝາກ"
                                                  : title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          'ເລກອ້າງອີງ: ${tx.txrefid}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14.sp,
                                          ),
                                        ),

                                        Text(
                                          'ຫາບັນຊີ: ${tx.usrname}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          'ລາຍລະອຽດ: ${tx.descs}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.sp,
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
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            NumberFormat.currency(
                                              locale: 'en_US',
                                              symbol: 'ກີບ',
                                              decimalDigits: 2,
                                              customPattern: '#,##0.00 ¤',
                                            ).format(tx.amt),
                                            style: TextStyle(
                                              color: iconColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: state.isLoading && transactionList.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    'ກຳລັງໂຫຼດຂໍ້ມູນເພີ່ມ...',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
