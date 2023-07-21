import 'package:flutter/material.dart';
import 'package:web_dashboard/view_model/home_page_view_model.dart';
import 'package:web_dashboard/theme_manager.dart';
import 'package:web_dashboard/views/dashboards/dashboard_test_view.dart';
import 'package:web_dashboard/views/dashboards/dashboard_one_view.dart';
import 'package:web_dashboard/views/dashboards/dashboard_two_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
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
        ChangeNotifierProvider(create: (context) => HomePageBaseViewModel()),
        ChangeNotifierProvider(create: (context) => DashboardThemeManager())
      ],
      child: Consumer<DashboardThemeManager>(
        builder: (context, themeManager, child) => MaterialApp(
          title: 'web dashboard project',
          theme: themeManager.theme,
          routes: {
            "/dashboard/1": (context) => const DashBoardOneView(),
            "/dashboard/2": (context) => const DashBoardTwoView(),
            "/dashboard/test": (context) => const DashBoardTestView(),
          },
          initialRoute: "/dashboard/test",
          onGenerateRoute: (settings) {
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                // 页面构建器
                switch (settings.name) {
                  case '/dashboard/1':
                    return const DashBoardOneView();
                  case '/dashboard/2':
                    return const DashBoardTwoView();
                  case '/dashboard/test':
                    return const DashBoardTestView();
                  default:
                    return const DashBoardOneView();
                }
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
          // home: const HomePageBaseView(),
        ),
      ),
    );
  }
}
