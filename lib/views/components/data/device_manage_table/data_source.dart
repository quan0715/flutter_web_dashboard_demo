import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';
import 'package:web_dashboard/views/components/data/device_manage_table/config.dart';

class DeviceManagingTableDataSource extends DataGridSource{
  List<MonitoringDeviceModel> dataSource;
  DeviceManagingTableDataSource({required this.dataSource});

  @override
  List<DataGridRow> get rows => dataSource
    .map<DataGridRow>(DeviceManageTableConfig.getRows)
    .toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) 
        => Align(
          alignment: Alignment.center,
          child: Text(dataCell.value.toString()))).toList()
    );
  }
}