import 'package:flutter/material.dart';
import 'package:web_dashboard/view_model/theme_manager.dart';
import 'package:web_dashboard/views/dashboards/dashboard_test_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_dashboard/views/auth/login_view.dart';
import 'firebase_options.dart';

Future<void> main() async {
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
        // ChangeNotifierProvider(create: (context) => HomePageBaseViewModel()),
        ChangeNotifierProvider(create: (context) => DashboardThemeManager())
      ],
      child: Consumer<DashboardThemeManager>(
        builder: (context, themeManager, child) => MaterialApp(
          title: 'web dashboard project',
          theme: themeManager.theme,
          routes: {
            "/dashboard/test": (context) => const DashBoardTestView(),
            "/login":(context) => const LoginPageView(),
          },
          initialRoute: "/login",

        ),
      ),
    );
  }
}
