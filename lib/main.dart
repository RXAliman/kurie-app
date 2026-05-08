import 'package:flutter/material.dart';
import 'app/theme/kurie_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/log_meter_reading_screen.dart';
import 'screens/billing_config_screen.dart';
import 'screens/property_management_screen.dart';
import 'screens/add_submeter_screen.dart';
import 'screens/notification_center_screen.dart';

void main() {
  runApp(const KurieApp());
}

class KurieApp extends StatelessWidget {
  const KurieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kurie',
      debugShowCheckedModeBanner: false,
      theme: KurieTheme.light,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/log_reading': (context) => const LogMeterReadingScreen(),
        '/billing_config': (context) => const BillingConfigScreen(),
        '/property_mgmt': (context) => const PropertyManagementScreen(),
        '/add_submeter': (context) => const AddSubmeterScreen(),
        '/notifications': (context) => const NotificationCenterScreen(),
      },
    );
  }
}
