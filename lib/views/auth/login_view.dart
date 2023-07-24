// login page view for admin

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/view_model/theme_manager.dart';
import 'package:web_dashboard/theme/theme.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardThemeManager>(
      builder: (context, themeManager, child) => Scaffold(
        body: Stack(
          children: [ 
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: DashboardColor.surface(context),
                  boxShadow: [
                    BoxShadow(
                      color: DashboardColor.primary(context),
                      blurRadius: 5,
                      spreadRadius: 6,
                      // blurStyle: BlurStyle.solid,
                      offset: const Offset(0, 0)
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                height: MediaQuery.of(context).size.height* 0.5,
                width: MediaQuery.of(context).size.height* 0.6,
                child: DashboardPadding.object(
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text("登入", style: DashboardText.headLineLarge(context)),
                        DashboardPadding.small(
                          child: Column(
                            children: [
                              Container(
                                width: 300,
                                height: 90,
                                decoration: const BoxDecoration(
                                  // color: const DashboardColor.error(context),
                                  image:  DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("ibm/IBM_logo_dark.png"),
                                  )
                                ),
                              ),
                              // Text("IBM 能源管理平台", style: DashboardText.headLineLarge(context),),
                              // Text("歡迎使用 IBM電力能源追蹤數據儀表板", style: DashboardText.labelLarge(context),),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DashboardPadding.small(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person),
                                      labelText: "帳號",
                                      hintText: "請輸入帳號",
                                      border: UnderlineInputBorder()
                                    ),
                                  ),
                                ),
                                DashboardPadding.small(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.lock),
                                      labelText: "密碼",
                                      hintText: "請輸入密碼",
                                      border: UnderlineInputBorder()
                                    ),
                                  ),
                                ),
                                DashboardPadding.small(
                                  child: MaterialButton(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: DashboardColor.secondary(context),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: (){
                                      Navigator.pushNamed(context, "/dashboard/test");
                                    }, 
                                    child: Text("登入", style: DashboardText.titleMedium(context),)
                                  ),
                                )
                              ],
                          )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}