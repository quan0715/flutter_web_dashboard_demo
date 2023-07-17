import 'package:flutter/material.dart';
import 'package:prologium_project_demo/view_model/dashboard/dashboard_view_model.dart';
import 'package:prologium_project_demo/views/chart/ammeter_error_report_col.dart';
import 'package:prologium_project_demo/views/common/color.dart';
import 'package:prologium_project_demo/views/common/sizedbox.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ErrorReportDataGrid extends StatelessWidget {
  const ErrorReportDataGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ElectricityDataDashboardViewModel>(
      builder: (context, electricityDataDashboardViewModel, child) =>
          SfDataGrid(
        //footer: Spacer(),
        isScrollbarAlwaysShown: true,
        verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
        shrinkWrapRows: true,
        gridLinesVisibility: GridLinesVisibility.vertical,
        headerGridLinesVisibility: GridLinesVisibility.vertical,
        columnWidthMode: ColumnWidthMode.fill,

        source: AmmeterGridDataSource(
            dataSource:
                electricityDataDashboardViewModel.ammeterErrorReportList),
        columns: [
          GridColumn(
              columnName: '設備編號',
              label: Container(
                color: DashboardColor.surfaceVariant(context).withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.inbox),
                    // DashboardSizedBox.small(),
                    Text('設備編號'),
                  ],
                ),
              )),
          GridColumn(
              columnName: '設備名稱',
              label: Container(
                color: DashboardColor.surfaceVariant(context).withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.device_hub),
                    // DashboardSizedBox.small(),
                    Text('設備名稱'),
                  ],
                ),
              )),
          GridColumn(
              columnName: '開始時間',
              label: Container(
                color: DashboardColor.surfaceVariant(context).withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Icon(Icons.timer),
                    // DashboardSizedBox.small(),
                    Text('發生時間'),
                  ],
                ),
              )),
          GridColumn(
              columnName: '正常邊界',
              label: Container(
                color: DashboardColor.surfaceVariant(context).withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.battery_0_bar),
                    // DashboardSizedBox.small(),
                    Text('正常邊界(KW)'),
                  ],
                ),
              )),
          GridColumn(
              columnName: '異常數值',
              label: Container(
                color: DashboardColor.surfaceVariant(context).withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.electrical_services_rounded),
                    // DashboardSizedBox.small(),
                    Text('異常數值(KW)'),
                  ],
                ),
              )),
          GridColumn(
              columnName: '異常狀態',
              label: Container(
                color: DashboardColor.surfaceVariant(context).withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.error),
                    // DashboardSizedBox.small(),
                    Text('異常狀態'),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
