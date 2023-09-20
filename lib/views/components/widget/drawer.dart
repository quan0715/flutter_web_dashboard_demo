// This file contains the drawer widget
// Compare this snippet from lib/views/home_page.dart:
// slide drawer need to be in the same level as the scaffold
// contain logout button and user info
// router for different dashboard and toggle theme

import 'package:flutter/material.dart';
import 'package:web_dashboard/view_model/auth_manager.dart';
import 'package:web_dashboard/view_model/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';
import 'package:web_dashboard/views/theme/color.dart';
import 'package:web_dashboard/views/theme/sized_box.dart';
import 'package:web_dashboard/views/theme/text.dart';

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
      builder: (context, themeManager, child) => Consumer<AuthManager>(
        builder: (context, authManager, _) => Drawer(
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
                              RawChip(
                                side: BorderSide.none,
                                avatar: Icon(Icons.factory_rounded, color: DashboardColor.primary(context)),
                                label: const Text("G1 廠")
                              ),
                          ]),
                        ),
                        DashboardSizedBox.large(),
                        const FrameQuote(quoteText: "數據儀表板",),
                        ListTile(
                          leading: const Icon(Icons.dashboard),
                          title: const Text('用電紀錄監測報告'),
                          onTap: () => Navigator.pushNamed(context, "/dashboard/device_consumption_report"),
                        ),
                        ListTile(
                          // isThreeLine: true,
                          leading: const Icon(Icons.analytics),
                          title: const Text('電力紀錄使用報告'),
                          onTap: () => Navigator.pushNamed(context, "/dashboard/report"),
                        ),
                        const FrameQuote(quoteText: "數據記錄(表格)",),
                        ListTile(
                          // isThreeLine: true,
                          leading: const Icon(Icons.analytics),
                          title: const Text('Scada 監控點數據'),
                          onTap: () => Navigator.pushNamed(context, "/dashboard/scada_table"),
                        ),
                        ListTile(
                          // isThreeLine: true,
                          leading: const Icon(Icons.analytics),
                          title: const Text('每日數據累績監控數據'),
                          onTap: () => Navigator.pushNamed(context, "/dashboard/daily_scada_sum_table"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.error),
                          // isThreeLine: true,
                          title: const Text('用電異常清單'),
                          onTap: () => Navigator.pushNamed(context, "/dashboard/device_error_report")
                          
                        ),
                        const FrameQuote(quoteText: "儀表板設定"), 
                        ListTile(
                          leading: const Icon(Icons.factory),
                          // isThreeLine: true,
                          title: const Text('設備管理'),
                          onTap: () => Navigator.pushNamed(context, "/dashboard/monitoring_device_manage"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('帳戶設定'),
                          onTap: () => Navigator.pushNamed(context, "/dashboard/config")
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
                  },
                ),
                ListTile(
                  iconColor: DashboardColor.error(context),
                  textColor: DashboardColor.error(context),
                  leading: const Icon(Icons.logout),
                  title: const Text('登出', ),
                  onTap: () async{
                    await authManager.logout();
                    if(context.mounted){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("登出成功")));
                      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                    }
                  },
                ),
                DashboardSizedBox.large()
              ],
            ),
          )),
      ),
    );
  }
}