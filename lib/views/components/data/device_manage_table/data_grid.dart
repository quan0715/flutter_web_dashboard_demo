import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/monitoring_device.dart';
import 'package:web_dashboard/theme/theme.dart';
import 'package:web_dashboard/views/components/data/device_manage_table/data_source.dart';

class DeviceManagingTableDataGrid extends StatelessWidget{
  final List<MonitoringDeviceModel> dataSource;
  DeviceManagingTableDataGrid({super.key, required this.dataSource});
  final columnsLabel = [ {
      "name" : "工廠",
      "label" : "工廠",
    },{
      "name" : "區域",
      "label" : "區域",
    },{
      "name" : "群組編號",
      "label" : "群組編號",
    },{
      "name" : "設備編號",
      "label" : "設備編號",
    },{
      "name" : "詳述",
      "label" : "詳述",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: DashboardColor.tertiaryContainer(context),
        rowHoverColor: DashboardColor.primaryContainer(context),
        rowHoverTextStyle: DashboardText.titleMedium(context).copyWith(color: DashboardColor.onPrimaryContainer(context)),
        gridLineStrokeWidth: 1,
        gridLineColor: DashboardColor.primary(context).withOpacity(0.2)
      ),
      child: SfDataGrid(
        // isScrollbarAlwaysShown: true,
        allowFiltering: true,
        // allowColumnsDragging: true,
        // allowColumnsResizing: true,
        allowPullToRefresh: true,
        allowMultiColumnSorting: true,
        gridLinesVisibility: GridLinesVisibility.vertical,
        headerGridLinesVisibility: GridLinesVisibility.vertical,
        columnWidthMode: ColumnWidthMode.fill,
        source: DeviceManagingTableDataSource(dataSource: dataSource),
        columns: columnsLabel.map((c) => GridColumn(
          columnName: c["name"] as String,
          label: Container(
            // color: DashboardColor.secondaryContainer(context),
            child: Center(
              child: Text(c["label"] as String, style: DashboardText.titleMedium(context).copyWith(
                color: DashboardColor.onTertiaryContainer(context),
              )),
            ),
          ),
        )).toList()
      ),
    );
  }
}