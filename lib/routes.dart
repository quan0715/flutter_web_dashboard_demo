// // the routes for the app

// import 'package:flutter/material.dart';
// import 'package:prologium_project_demo/views/home_page_base.dart';

// class AppRoute {
//   static Route<dynamic> onGenerateRoute(RouteSettings settings) {
//     MaterialPageRoute nextPage;
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute<dynamic>(
//             builder: (context) => const HomePageBaseView(), settings: settings);
//       case '/dashboard1':
//         return MaterialPageRoute<dynamic>(
//             builder: (context) => const HomePageBaseView(), settings: settings);
//       case '/dashboard2':
//         return MaterialPageRoute<dynamic>(
//             builder: (context) => const HomePageBaseView(), settings: settings);
//       default:
//         return MaterialPageRoute<dynamic>(
//           builder: (context) => const HomePageBaseView(), settings: settings);
//     }
//   }

//   // static MaterialPageRoute<dynamic> onUnknownRoute(RouteSettings settings) {
//   //   return MaterialPageRoute<dynamic>(
//   //     settings: settings,
//   //     builder: (context) => const ErrorPage('Not Found'),
//   //   );
//   // }
// }
