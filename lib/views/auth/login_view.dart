// login page view for admin

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/view_model/auth_manager.dart';
import 'package:web_dashboard/view_model/theme_manager.dart';
import 'package:web_dashboard/theme/theme.dart';

class LoginPageView extends StatelessWidget {
  LoginPageView({super.key});
  final formKey = GlobalKey<FormState>();

  Widget accountTextField(AuthManager authManager){
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: "帳號",
        hintText: "請輸入帳號",
        border: UnderlineInputBorder()
      ),
      initialValue: authManager.account,
      validator: authManager.accountValidator,
      onChanged: (account) => authManager.setAccount(account),
    );
  }

  Widget passwordTextField(AuthManager authManager){
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.lock),
        labelText: "密碼",
        hintText: "請輸入密碼",
        border: UnderlineInputBorder(),
      ),
      initialValue: authManager.password,
      obscureText: true,
      validator: authManager.passwordValidator,
      onChanged: (password) => authManager.setPassword(password),
    );
  }

  Widget loginButton(AuthManager authManager, {BuildContext? context}){
    return MaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: DashboardColor.secondary(context!),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () async {
        if(formKey.currentState!.validate())  {
          await authManager.login();
          if(authManager.isLogin && context.mounted){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                elevation: 4,
                behavior: SnackBarBehavior.floating,
                content: Text("登入成功")
              )
            );
            Navigator.pushNamed(context, "/dashboard/main");
          }else{
            debugPrint("login fail");
          }
        }
      }, 
      child: Text("登入", style: DashboardText.titleMedium(context),)
    );
  }

  Color getShadowColor(AuthManager authManager, BuildContext context){
    if(authManager.isError == null){
      return DashboardColor.primary(context);
    }else if(authManager.isError!){
      return DashboardColor.error(context);
    }else{
      return DashboardColor.correct;
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(
      builder: (context, authManager, child) => 
        Consumer<DashboardThemeManager>(
        builder: (context, themeManager, child) => Scaffold(
          body: Stack(
            children: [ 
              Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: DashboardColor.surface(context),
                    boxShadow: [
                      BoxShadow(
                        color: getShadowColor(authManager, context),
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
                      child: authManager.isLoading
                      ? const Center(
                        child: SizedBox.square(dimension: 50, child: CircularProgressIndicator(),),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DashboardPadding.small(
                            child: Column(
                              children: [
                                Container(
                                  width: 300,
                                  height: 90,
                                  decoration: const BoxDecoration(
                                    // color: const DashboardColor.error(context),
                                    image: DecorationImage(
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
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DashboardPadding.small(
                                    child: accountTextField(authManager)
                                  ),
                                  DashboardPadding.small(
                                    child: passwordTextField(authManager)
                                  ),
                                  DashboardPadding.small(
                                    child: loginButton(authManager, context: context),
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
      ),
    );
  }
}