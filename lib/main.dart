import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kurie/firebase_options.dart';
import 'package:provider/provider.dart';
import 'data/repositories/app_repository.dart';
import 'app/theme/kurie_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/log_meter_reading_screen.dart';
import 'screens/billing_config_screen.dart';
import 'screens/property_management_screen.dart';
import 'screens/add_submeter_screen.dart';
import 'screens/notification_center_screen.dart';
import 'screens/dispute_resolution_screen.dart';
import 'screens/bill_details_screen.dart';
import 'screens/register_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'data/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().init();

  final repository = AppRepository();
  await repository.init();

  // Check if user is already logged in
  final currentUser = FirebaseAuth.instance.currentUser;
  final initialRoute = currentUser != null ? '/home' : '/onboarding';

  runApp(
    ChangeNotifierProvider(
      create: (_) => repository,
      child: KurieApp(initialRoute: initialRoute),
    ),
  );
}

class KurieApp extends StatelessWidget {
  final String initialRoute;
  const KurieApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppRepository>(
      builder: (context, repository, child) {
        return MaterialApp(
          title: 'Kurie',
          debugShowCheckedModeBanner: false,
          theme: KurieTheme.light,
          darkTheme: KurieTheme.dark,
          themeMode: repository.themeMode,
          initialRoute: initialRoute,
          routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/log_reading': (context) => const LogMeterReadingScreen(),
        '/billing_config': (context) => const BillingConfigScreen(),
        '/property_mgmt': (context) => const PropertyManagementScreen(),
        '/add_submeter': (context) => const AddSubmeterScreen(),
        '/notifications': (context) => const NotificationCenterScreen(),
        '/dispute_resolution': (context) => const DisputeResolutionScreen(),
        '/bill_details': (context) {
          final billId = ModalRoute.of(context)!.settings.arguments as String;
          return BillDetailsScreen(billId: billId);
        },
      },
        );
      },
    );
  }
}
