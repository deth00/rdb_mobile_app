import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moblie_banking/core/utils/nav.dart';
import 'package:moblie_banking/features/account/presentation/account_screen.dart';
import 'package:moblie_banking/features/auth/presentation/check_phone_screen.dart';
import 'package:moblie_banking/features/auth/presentation/create_password_screen.dart';
import 'package:moblie_banking/features/auth/presentation/forget_password_screen.dart';
import 'package:moblie_banking/features/auth/presentation/login_screen.dart';
import 'package:moblie_banking/features/otp/presentation/otp_forgot_pw.dart';
import 'package:moblie_banking/features/auth/presentation/register_screen.dart';
import 'package:moblie_banking/features/deposit/presentation/comingsoon.dart';
import 'package:moblie_banking/features/deposit/presentation/home_deposit.dart';
import 'package:moblie_banking/features/deposit/presentation/transfer_money.dart';
import 'package:moblie_banking/features/home/presentation/home_screen.dart';
import 'package:moblie_banking/features/loan/presentation/check_payment.dart';
import 'package:moblie_banking/features/loan/presentation/home_loan.dart';
import 'package:moblie_banking/features/otp/presentation/otp_register.dart';
import 'package:moblie_banking/features/services/presentation/service_screen.dart';
import 'package:moblie_banking/features/settings/presentation/setting_screen.dart';
import 'package:moblie_banking/features/splash/splash_screen.dart';
import 'package:moblie_banking/features/transaction/presentation/transaction_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // final authRedirect = ref.watch(authRedirectProvider);

  return GoRouter(
    initialLocation: '/',
    // debugLogDiagnostics: true,
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
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/checkPhone',
        builder: (context, state) => const CheckPhoneScreen(),
      ),
      GoRoute(
        path: '/forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otpforgot',
        builder: (context, state) => const OtpForgotPW(),
      ),
      GoRoute(
        path: '/otpregis',
        builder: (context, state) => const OtpRegister(),
      ),
      GoRoute(
        path: '/createPW',
        builder: (context, state) => const CreatePasswordScreen(),
      ),
      GoRoute(
        path: '/transfer',
        builder: (context, state) => const TransferMoney(),
      ),
      GoRoute(
        path: '/commingsoon',
        builder: (context, state) => const ComingSoonScreen(),
      ),
      GoRoute(
        path: '/check',
        builder: (context, state) => const CheckPaymentScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => NavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/deposit',
            builder: (context, state) => const HomeDeposit(),
          ),
          GoRoute(path: '/loan', builder: (context, state) => const HomeLoan()),
          GoRoute(
            path: '/account',
            builder: (context, state) => const AccountScreen(),
          ),
          GoRoute(
            path: '/transactions',
            builder: (context, state) => const TransactionScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingScreen(),
          ),
          GoRoute(
            path: '/services',
            builder: (context, state) => const ServiceScreen(),
          ),
        ],
      ),
    ],
  );
});
