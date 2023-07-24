// This file contains the drawer widget
// Compare this snippet from lib/views/home_page.dart:
// slide drawer need to be in the same level as the scaffold
// contain logout button and user info
// router for different dashboard and toggle theme

import 'package:flutter/material.dart';
import 'package:web_dashboard/view_model/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/views/components/quote.dart';
import 'package:web_dashboard/theme/color.dart';
import 'package:web_dashboard/theme/sized_box.dart';
import 'package:web_dashboard/theme/text.dart';

class DashboardDrawer extends StatelessWidget{
  // implement dashboard drawer
  const DashboardDrawer({super.key});

  Widget premiumLabelChip(){
    return Chip(
      backgroundColor: Colors.amber.shade700,
      labelStyle: const TextStyle(color: Colors.white),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.zero,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      visualDensity: VisualDensity.compact,
      label: const Text("Premium"),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardThemeManager>(
      builder: (context, themeManager, child) => Drawer(
        elevation: 1,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                  // padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        curve: Curves.linear,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                // color: DashboardColor.surface(context),
                                image: DecorationImage(
                                  image: AssetImage(themeManager.logoPath),
                                  fit: BoxFit.cover,
                                )
                              )
                            ),
                            DashboardSizedBox.small(),
                            Text("輝能能源管理平台", style: DashboardText.headLineSmall(context),),
                            DashboardSizedBox.small(),
                            premiumLabelChip() 
                        ]),
                      ),
                      DashboardSizedBox.large(),
                      const FrameQuote(quoteText: "儀表板",),
                      ListTile(
                        leading: const Icon(Icons.dashboard),
                        // isThreeLine: true,
                        title: const Text('用電紀錄儀表板'),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.dashboard),
                        // isThreeLine: true,
                        title: const Text('電表數據總覽'),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      ListTile(
                        // isThreeLine: true,
                        leading: const Icon(Icons.analytics),
                        title: const Text('未來電力預測分析'),
                        // trailing: premiumLabelChip(),
                        // subtitle: const Text('Secondary Text'),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      const FrameQuote(quoteText: "資料設定",), 
                      ListTile(
                        leading: const Icon(Icons.error),
                        // isThreeLine: true,
                        title: const Text('錯誤回報紀錄'),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.factory),
                        // isThreeLine: true,
                        title: const Text('設備管理'),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('帳戶設定'),
                        onTap: () {
                          // Update the state of the app.
                          // ...
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                // isThreeLine: true,
                leading: Icon(themeManager.icon),
                title: Text('主題: ${themeManager.isDark ? "深色" : "淺色"}'),
                trailing: Switch(
                  value: themeManager.isDark, onChanged: (value){
                  themeManager.toggleTheme();
                },),
                onTap: () {
                  themeManager.toggleTheme();
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                iconColor: DashboardColor.error(context),
                textColor: DashboardColor.error(context),
                // isThreeLine: true,
                leading: const Icon(Icons.logout),
                title: const Text('登出', ),
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                
                },
              ),
              DashboardSizedBox.large()
            ],
          ),
        )),
    );
  }
}