import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/nav.dart';
import 'package:moblie_banking/features/account/presentation/account_screen.dart';
import 'package:moblie_banking/features/auth/logic/auth_provider.dart';
import 'package:moblie_banking/features/auth/presentation/check_phone_screen.dart';
import 'package:moblie_banking/features/auth/presentation/create_password_screen.dart';
import 'package:moblie_banking/features/auth/presentation/forget_password_screen.dart';
import 'package:moblie_banking/features/auth/presentation/logged_in_login_screen.dart';
import 'package:moblie_banking/features/auth/presentation/login_screen.dart';
import 'package:moblie_banking/features/deposit/financial/presentation/finan_home.dart';
import 'package:moblie_banking/features/deposit/transaction/presentation/transaction_screen.dart';
import 'package:moblie_banking/features/deposit/transaction/presentation/transaction_detail_screen.dart';
import 'package:moblie_banking/core/models/transaction_model.dart';
import 'package:moblie_banking/features/deposit/account/presentation/select_primary_account_screen.dart';
import 'package:moblie_banking/features/notification/presentation/notification_detail_screen.dart';
import 'package:moblie_banking/core/utils/route_constants.dart';
import 'package:moblie_banking/features/otp/presentation/otp_forgot_pw.dart';
import 'package:moblie_banking/features/auth/presentation/register_screen.dart';
import 'package:moblie_banking/features/deposit/transfer/presentation/comingsoon.dart';
import 'package:moblie_banking/features/deposit/transfer/presentation/add_transfer_money.dart';
import 'package:moblie_banking/features/deposit/transfer/presentation/add_balance_screen.dart';
import 'package:moblie_banking/features/deposit/้home/presentation/home_deposit.dart';
import 'package:moblie_banking/features/deposit/้home/presentation/add_account_screen.dart';
import 'package:moblie_banking/features/deposit/้home/presentation/fund_account_detail_screen.dart';
import 'package:moblie_banking/features/deposit/transfer/presentation/transfer_money.dart';
import 'package:moblie_banking/features/home/presentation/qr_screen.dart';
import 'package:moblie_banking/features/home/presentation/home_screen.dart';
import 'package:moblie_banking/features/home/presentation/scan_qr_page.dart';
import 'package:moblie_banking/features/loan/presentation/check_payment.dart';
import 'package:moblie_banking/features/loan/presentation/home_loan.dart';
import 'package:moblie_banking/features/otp/presentation/otp_register.dart';
import 'package:moblie_banking/features/services/presentation/service_screen.dart';
import 'package:moblie_banking/features/settings/presentation/setting_screen.dart';
import 'package:moblie_banking/features/splash/splash_screen.dart';
import 'package:moblie_banking/features/calendar/presentation/calendar_screen.dart';
import 'package:moblie_banking/features/notification/presentation/notification_screen.dart';
import 'package:moblie_banking/features/webview/presentation/webview_screen.dart';
import 'package:moblie_banking/features/location/presentation/location_screen.dart';
import 'package:moblie_banking/features/location/presentation/map_screen.dart';
import 'package:moblie_banking/features/settings/presentation/check_device_screen.dart';
import 'package:moblie_banking/features/auth/presentation/add_password_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // final authRedirect = ref.watch(authRedirectProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
    // refreshListenable: authRedirect,
    // redirect: (context, state) {
    //   final loggedIn = authRedirect.isLoggedIn;
    //   final onLogin = state.uri.path == '/login';

    //   if (!loggedIn && !onLogin) return '/login';
    //   if (loggedIn && onLogin) return '/home';
    //   if (!loggedIn && !onLogin) return '/register';

    //   return null;
    // },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/loginNever',
        name: 'loginNever',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoggedInLoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/checkPhone',
        name: 'checkPhone',
        builder: (context, state) => const CheckPhoneScreen(),
      ),
      GoRoute(
        path: '/forgotPassword',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otpforgot',
        name: 'otpforgot',
        builder: (context, state) => const OtpForgotPW(),
      ),
      GoRoute(
        path: '/otpregis',
        name: 'otpregis',
        builder: (context, state) => const OtpRegister(),
      ),
      GoRoute(
        path: '/createPW',
        name: 'createPW',
        builder: (context, state) => const CreatePasswordScreen(),
      ),
      GoRoute(
        path: '/addPassword',
        name: 'addPassword',
        builder: (context, state) {
          final redirectUrl = state.uri.queryParameters['redirectUrl'] ?? '';
          return AddPasswordScreen(redirectUrl: redirectUrl);
        },
      ),
      GoRoute(
        path: '/transfer',
        name: 'transfer',
        builder: (context, state) => const TransferMoney(),
      ),
      GoRoute(
        path: '/addTransferMoney/:acno',
        name: 'addTransferMoney',
        builder: (context, state) {
          final acno = state.pathParameters['acno'] ?? '';
          return AddTransferMoney(acno: acno);
        },
      ),
      GoRoute(
        path: '/addBalance',
        name: 'addBalance',
        builder: (context, state) => const AddBalanceScreen(),
      ),
      GoRoute(
        path: '/qr',
        name: 'accountQR',
        builder: (context, state) => const QrScreen(),
      ),
      GoRoute(
        path: '/addACDPT',
        name: 'addACDPT',
        builder: (context, state) => const AddAccountScreen(),
      ),
      GoRoute(
        path: '/scanQR',
        name: 'scanQR',
        builder: (context, state) => const ScanQRPage(),
      ),
      GoRoute(
        path: '/fundAccountDetail/:acno',
        name: 'fundAccountDetail',
        builder: (context, state) {
          final acno = state.pathParameters['acno'] ?? '';
          return FundAccountDetailScreen(acno: acno);
        },
      ),
      GoRoute(
        path: '/commingsoon',
        name: 'commingsoon',
        builder: (context, state) => const ComingSoonScreen(),
      ),
      GoRoute(
        path: '/check',
        name: 'check',
        builder: (context, state) => const CheckPaymentScreen(),
      ),
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/webview',
        name: 'webview',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'] ?? '';
          final title = state.uri.queryParameters['title'] ?? 'ເວັບໄຊທ໌';
          return WebViewScreen(url: url, title: title);
        },
      ),
      GoRoute(
        path: '/check-devices',
        name: 'checkDevices',
        builder: (context, state) => const CheckDevicePage(),
      ),
      GoRoute(
        path: '/financial',
        name: 'financial',
        builder: (context, state) => const FinancialPage(),
      ),
      GoRoute(
        path: '/select-primary-account',
        name: RouteConstants.selectPrimaryAccount,
        builder: (context, state) => const SelectPrimaryAccountScreen(),
      ),
      GoRoute(
        path: '/notification-detail/:id',
        name: RouteConstants.notificationDetail,
        builder: (context, state) {
          final notificationId = state.pathParameters['id'];
          return NotificationDetailScreen(notificationId: notificationId);
        },
      ),
      GoRoute(
        path: '/transaction-detail/:acno',
        name: RouteConstants.transactionDetail,
        builder: (context, state) {
          final acno = state.pathParameters['acno'] ?? '';
          final title =
              state.uri.queryParameters['title'] ?? 'Transaction Detail';

          // Get transaction data from extra parameter
          final transaction = state.extra as Transaction?;

          if (transaction == null) {
            // Fallback to default values if no transaction data
            return TransactionDetailScreen(
              transaction: Transaction(
                txcode: '',
                defacno: acno,
                stdt: DateTime.now().toString(),
                txrefid: '',
                amt: 0.0,
                descs: '',
                valuedt: DateTime.now().toString(),
                usrname: '',
                descr: '',
              ),
              title: title,
            );
          }

          return TransactionDetailScreen(
            transaction: transaction,
            title: title,
          );
        },
      ),

      ShellRoute(
        builder: (context, state, child) => NavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/deposit/:acno',
            name: 'homeDeposit',
            builder: (context, state) {
              final acno = state.pathParameters['acno'] ?? '';
              return HomeDeposit(acno: acno);
            },
          ),
          GoRoute(
            path: '/loan',
            name: 'loan',
            builder: (context, state) => const HomeLoan(),
          ),
          GoRoute(
            path: '/account',
            name: 'account',
            builder: (context, state) => const AccountScreen(),
          ),
          GoRoute(
            path: '/transactions/:acno',
            name: 'transactions',
            builder: (context, state) {
              final acno = state.pathParameters['acno'] ?? '';
              return TransactionScreen(acno: acno);
            },
          ),

          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingScreen(),
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (context, state) => const ServiceScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationScreen(),
          ),
          GoRoute(
            path: '/location',
            name: 'location',
            builder: (context, state) => const LocationScreen(),
          ),
          GoRoute(
            path: '/location/map/:locationId',
            name: 'locationMap',
            builder: (context, state) {
              final locationId =
                  int.tryParse(state.pathParameters['locationId'] ?? '1') ?? 1;
              return MapScreen(pageId: locationId);
            },
          ),
        ],
      ),
    ],
  );
});
