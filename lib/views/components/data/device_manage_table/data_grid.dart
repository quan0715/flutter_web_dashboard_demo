import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/monitoring_device.dart';
import 'package:web_dashboard/theme/theme.dart';
import 'package:web_dashboard/views/components/data/device_manage_table/data_source.dart';

class DeviceManagingTableDataGrid extends StatelessWidget{
  final List<MonitoringDeviceModel> dataSource;
  DeviceManagingTableDataGrid({super.key, required this.dataSource});
  final columnsLabel = [
    "工廠", "區域", "群組編號", "設備編號", "詳述", "修改者", "修改時間"
  ];
  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: DashboardColor.tertiaryContainer(context),
        rowHoverColor: DashboardColor.primaryContainer(context),
        // rowHoverTextStyle: DashboardText.titleMedium(context).copyWith(color: DashboardColor.onPrimaryContainer(context)),
        gridLineStrokeWidth: 1,
        gridLineColor: DashboardColor.primary(context).withOpacity(0.2)
      ),
      child: SfDataGrid(
        // isScrollbarAlwaysShown: true,
        // allowFiltering: true,
        // allowColumnsDragging: true,
        // allowColumnsResizing: true,
        // footer: Divider(thickness: 1,),
        allowPullToRefresh: true,
        allowMultiColumnSorting: true,
        gridLinesVisibility: GridLinesVisibility.vertical,
        headerGridLinesVisibility: GridLinesVisibility.vertical,
        columnWidthMode: ColumnWidthMode.fill,
        source: DeviceManagingTableDataSource(dataSource: dataSource),
        columns: columnsLabel.map((label) => GridColumn(
          columnName: label,
          label: Container(
            // color: DashboardColor.secondaryContainer(context),
            child: Center(
              child: Text(label, style: DashboardText.titleMedium(context).copyWith(
                color: DashboardColor.onTertiaryContainer(context),
              )),
            ),
          ),
        )).toList()
      ),
    );
  }
}