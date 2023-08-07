import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/views/theme/format.dart';

class ElectricityConsumptionDataSource extends DataGridSource{
  List<ElectricityConsumptionDataModel> dataSource;
  ElectricityConsumptionDataSource({required this.dataSource});

  @override
  List<DataGridRow> get rows => dataSource
    .map<DataGridRow>((data) => DataGridRow(cells: [
      DataGridCell<String>(columnName: '工廠', value: data.loc),
      DataGridCell<String>(columnName: '區域', value: data.building),
      DataGridCell<String>(columnName: '設備設備', value: data.assetType),
      DataGridCell<String>(columnName: '設備產線', value: data.lineType),
      DataGridCell<String>(columnName: '設備編號', value: data.tagId),
      DataGridCell<String>(columnName: '耗電', value: data.power.toString()),
      DataGridCell<String>(columnName: '電壓', value: data.volt.toString()),
      DataGridCell<String>(columnName: '電流', value: data.ampere.toString()),
      DataGridCell<String>(columnName: '耗電量', value: data.energyConsumed.toString()),
      DataGridCell<String>(columnName: '總耗電量', value: data.sumOfEnergyConsumed.toString()),
      DataGridCell<String>(columnName: '更新時間', value: DashBoardFormat.time(data.startTime!)),
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