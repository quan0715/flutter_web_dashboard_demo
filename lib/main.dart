import 'package:flutter/material.dart';
import 'package:web_dashboard/view_model/auth_manager.dart';
import 'package:web_dashboard/view_model/theme_manager.dart';
import 'package:web_dashboard/views/pages/data_table/device_error_report_view.dart';
import 'package:web_dashboard/views/pages/dashboard/electricity_consumption_dashboard_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_dashboard/views/pages/auth/login_view.dart';
import 'package:web_dashboard/views/pages/data_table/monitoring_device_manage_view.dart';
import 'views/config/firebase_options.dart';
import 'views/pages/dashboard/consumption_dashboard_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthManager()),
        ChangeNotifierProvider(create: (context) => DashboardThemeManager())
      ],
      child: Consumer<AuthManager>(
        builder: (context, authManager, child) => Consumer<DashboardThemeManager>(
          builder: (context, themeManager, child) => MaterialApp(
            title: 'web dashboard project',
            theme: themeManager.theme,
            routes: {
              "/dashboard/main": (context) => const ElectricityConsumptionDashboard(),
              "/dashboard/monitoring_device_manage": (context) => const MonitoringDeviceManageView(),
              "/dashboard/device_error_report": (context) => const DeviceErrorReportView(),
              "/dashboard/device_consumption_report": (context) => const ConsumptionReportView(),
              "/login": (context) => LoginPageView(),
              '/': (context) => LoginPageView(),
            },
            initialRoute: authManager.isLogin ? "/dashboard/main" : "/login",
          ),
        ),
      ),
    );
  }
}
