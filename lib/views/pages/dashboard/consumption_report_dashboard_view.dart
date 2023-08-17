import 'package:flutter/material.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';

class ConsumptionReportDashboardView extends StatelessWidget {
  const ConsumptionReportDashboardView({Key? key}) : super(key: key);
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