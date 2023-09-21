import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';
import 'package:web_dashboard/views/components/data/device_manage_table/config.dart';
import 'package:web_dashboard/views/theme/theme.dart';
import 'package:web_dashboard/views/components/data/device_manage_table/data_source.dart';

class DeviceManagingTableDataGrid extends StatelessWidget{
  final List<MonitoringDeviceModel> dataSource;
  const DeviceManagingTableDataGrid({super.key, required this.dataSource});
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // elevation: 0,
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          headerColor: DashboardColor.primary(context).withOpacity(0.2),
          // rowHoverColor: DashboardColor.primaryContainer(context),
          // rowHoverTextStyle: DashboardText.titleMedium(context).copyWith(color: DashboardColor.onPrimaryContainer(context)),
          gridLineStrokeWidth: 1,
          // gridLineColor: DashboardColor.primary(context).withOpacity(0.2)
        ),
        child: SfDataGrid(
          gridLinesVisibility: GridLinesVisibility.vertical,
          headerGridLinesVisibility: GridLinesVisibility.vertical,
          columnWidthMode: MediaQuery.sizeOf(context).width > 1200 ? ColumnWidthMode.fill : ColumnWidthMode.auto,
          source: DeviceManagingTableDataSource(dataSource: dataSource),
          columns: DeviceManageTableConfig.columName.map((label) => GridColumn(
            columnName: label,
            label: Center(
                child: Text(label, style: DashboardText.titleMedium(context).copyWith(
                  color: DashboardColor.onPrimaryContainer(context),
                )),
              ),
            ),
          ).toList()
        ),
      ),
    );
  }
}