
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/error_report.dart';
import 'package:web_dashboard/theme/format.dart';

class DeviceErrorReportTableDataSource extends DataGridSource{
  final List<DeviceErrorReportModel> dataSource;
  DeviceErrorReportTableDataSource({required this.dataSource});

  @override
  List<DataGridRow> get rows => dataSource
    .map<DataGridRow>((data) => DataGridRow(cells: [
      DataGridCell(columnName: "異常類別", value: data.errorType!.label),
      DataGridCell(columnName: "開始時間", value: DashBoardFormat.time(data.startTime!)),
      DataGridCell(columnName: "位置", value: data.loc),
      DataGridCell(columnName: "建築物", value: data.building),
      DataGridCell(columnName: "設備編號", value: data.tagId),
      DataGridCell(columnName: "當下電流", value: data.ampere),
      DataGridCell(columnName: "當下電壓", value: data.volt),
      DataGridCell(columnName: "當下功率", value: data.power),
      DataGridCell(columnName: "異常描述", value: data.errorDescription),
    ])).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataCell) => Align(
        alignment: Alignment.center,
        child: Text(dataCell.value.toString())
      )).toList()
    );
  }
}