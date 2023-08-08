import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/config.dart';
import 'package:web_dashboard/views/theme/color.dart';
import 'package:web_dashboard/views/theme/text.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/data_source.dart';

class DeviceErrorReportTableDataGrid extends StatelessWidget{
  final List<DeviceErrorReportModel> dataSource;
  final bool isLarge;
  const DeviceErrorReportTableDataGrid({super.key, required this.dataSource, this.isLarge = true});
  factory DeviceErrorReportTableDataGrid.largeView({required List<DeviceErrorReportModel> dataSource}){
    return DeviceErrorReportTableDataGrid(dataSource: dataSource, isLarge: true);
  }
  factory DeviceErrorReportTableDataGrid.smallView({required List<DeviceErrorReportModel> dataSource}){
    return DeviceErrorReportTableDataGrid(dataSource: dataSource, isLarge: false);
  }
  get columnsLabel => isLarge ? LargeViewDeviceErrorReportTableConfig.columName : SmallViewDeviceErrorReportTableConfig.columName;
  
  @override
  Widget build(BuildContext context) {
    // final columnsLabel = DeviceErrorReportTableDataSource(dataSource: dataSource).rows.first.getCells().map<String>((cell) => cell.columnName).toList();
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: isLarge ? DashboardColor.tertiaryContainer(context) : null 
      ),
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.fill,
        source: DeviceErrorReportTableDataSource(dataSource: dataSource, isLarge: isLarge), 
        columns: columnsLabel.map<GridColumn>(
          (col) => GridColumn(
            columnName: col,
            label: Align(
              alignment: Alignment.center,
              child: Text(col, style: DashboardText.titleSmall(context).copyWith(
                color:  isLarge 
                  ? DashboardColor.onTertiaryContainer(context)
                  : DashboardColor.onSurface(context)
              )),
            ),
          )
        ).toList(),
      ),
    );
  }
}