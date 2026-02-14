import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: OminiFlowApp(),
    ),
  );
}

class OminiFlowApp extends StatelessWidget {
  const OminiFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OminiFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getDarkTheme('lash_studio'),
      home: const DashboardScreen(),
    );
  }
}
