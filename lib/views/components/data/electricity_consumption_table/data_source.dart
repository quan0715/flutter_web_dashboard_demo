import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/config.dart';

class ElectricityConsumptionDataSource extends DataGridSource{
  List<ElectricityConsumptionDataModel> dataSource;
  ElectricityConsumptionDataSource({required this.dataSource});

  @override
  List<DataGridRow> get rows => dataSource
    .map<DataGridRow>(ConsumptionTableConfig.getRows)
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