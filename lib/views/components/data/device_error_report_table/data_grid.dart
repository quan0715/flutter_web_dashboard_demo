import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/views/theme/color.dart';
import 'package:web_dashboard/views/theme/text.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/data_source.dart';

class DeviceErrorReportTableDataGrid extends StatelessWidget{
  final List<DeviceErrorReportModel> dataSource;
  DeviceErrorReportTableDataGrid({super.key, required this.dataSource});
  final columnsLabel = [
    "異常類別",
    "開始時間", 
    "位置",
    "建築物",
    "設備編號",
    "當下電流",
    "當下電壓",
    "當下功率", 
    "UB",
    "LB"
  ];
  
  @override
  Widget build(BuildContext context) {
    // final columnsLabel = DeviceErrorReportTableDataSource(dataSource: dataSource).rows.first.getCells().map<String>((cell) => cell.columnName).toList();
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: DashboardColor.tertiaryContainer(context)
      ),
      child: SfDataGrid(
        // shrinkWrapRows: true,
        // allowFiltering: true,
        columnWidthMode: ColumnWidthMode.fill,
        source: DeviceErrorReportTableDataSource(dataSource: dataSource), 
        columns: columnsLabel.map<GridColumn>(
          (col) => GridColumn(
            columnName: col,
            label: Align(
              alignment: Alignment.center,
              child: Text(col, style: DashboardText.titleSmall(context).copyWith(
                color: DashboardColor.onTertiaryContainer(context),
              )),
            ),
          )
        ).toList(),
      ),
    );
  }
}