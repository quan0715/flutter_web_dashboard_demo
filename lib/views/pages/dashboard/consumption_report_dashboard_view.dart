import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';

import '../../theme/theme.dart';

class ConsumptionReportDashboardView extends StatefulWidget {
  const ConsumptionReportDashboardView({Key? key}) : super(key: key);

  @override
  State<ConsumptionReportDashboardView> createState() => _ConsumptionReportDashboardViewState();
}

class _ConsumptionReportDashboardViewState extends State<ConsumptionReportDashboardView> {

    Widget loadingView(){
      return const Center(
        child: CircularProgressIndicator(),
      ).animate();
    }

  Widget normalScreenSizeView(BoxConstraints constraints){
    return Center(
      child: Text("layout not support", style: DashboardText.labelLarge(context)),
    );

  }

  Widget smallScreenSizeView(BoxConstraints constraints){
    return Center(
      child: Text("layout not support", style: DashboardText.labelLarge(context)),
    );
  }

  Widget noneSupportScreenSizeView(){
    return Center(
      child: Text("layout not support", style: DashboardText.labelLarge(context)),
    );
  }

  Widget noneDataDialogView(){
    return Center(
      child: Text("no data", style: DashboardText.labelLarge(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
  return const Scaffold(
        appBar: DashboardAppBar(title: "用電紀錄監測報告"),
        drawer: DashboardDrawer(),
        body: Center(
          child: Text(
            'Consumption Report Dashboard',
          ),
        ),
      );
  }
}