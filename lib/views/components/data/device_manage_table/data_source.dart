import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class DeviceManagingTableDataSource extends DataGridSource{
  List<MonitoringDeviceModel> dataSource;
  DeviceManagingTableDataSource({required this.dataSource});

  @override
  List<DataGridRow> get rows => dataSource
    .map<DataGridRow>((data) => DataGridRow(cells: [
      DataGridCell<String>(columnName: '工廠', value: data.loc),
      DataGridCell<String>(columnName: '區域', value: data.building),
      DataGridCell<String>(columnName: '設備編號', value: data.tagId),
      DataGridCell<String>(columnName: '設備類型', value: data.assetType ?? ""),
      DataGridCell<String>(columnName: '產線類型', value: data.lineType ?? ""),
      DataGridCell<String>(columnName: '用電部門', value: data.department ?? ""),
      DataGridCell<String>(columnName:  "Ub", value: data.ub.toString()),
      DataGridCell<String>(columnName:  "Lb", value: data.lb.toString()),
      DataGridCell<String>(columnName:  "WUb", value: data.wub.toString()),
      DataGridCell<String>(columnName:  "WLb", value: data.wlb.toString()),
      DataGridCell<String>(columnName: '修改者', value: data.changeBy ?? ""),
      DataGridCell<String>(columnName: '修改時間', value: DashBoardFormat.time(data.changeDate!)),
    ]))
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