import 'package:flutter/material.dart';
import 'package:prologium_project_demo/view_model/home_page_view_model.dart';
import 'package:prologium_project_demo/views/dashboard/dashboard_test_view.dart';
import 'package:prologium_project_demo/views/dashboard/dashboard_one_view.dart';
import 'package:prologium_project_demo/views/dashboard/dashboard_two_view.dart';
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
        ChangeNotifierProvider(
          create: (context) => HomePageBaseViewModel()),
      ],
      child: MaterialApp(
        title: 'web dashboard project',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        routes: {
          "/dashboard/1": (context) => const DashBoardOneView(),
          "/dashboard/2": (context) => const DashBoardTwoView(),
          "/dashboard/test": (context) => const DashBoardTestView(),
        },
        initialRoute: "/dashboard/1",
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              // 页面构建器
              switch(settings.name){
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
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // 过渡效果构建器
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
        // home: const HomePageBaseView(),
      ),
    );
  }
}
