import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/app/theme/app_theme.dart';
import 'package:moblie_banking/app/routes/app_router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final router = ref.watch(goRouterProvider);
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.main,
        routerConfig: router,
        builder: (context, child) {
          return child ??
              const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    } catch (e) {
      // Fallback if router fails to initialize
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.main,
        home: const Scaffold(body: Center(child: Text('Initializing...'))),
      );
    }
  }
}
