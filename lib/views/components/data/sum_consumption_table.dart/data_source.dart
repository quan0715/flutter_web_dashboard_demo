import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/components/data/sum_consumption_table.dart/config.dart';


class SumOfElectricityConsumptionDataSource extends DataGridSource{
  List<SumOfElectricityConsumptionDataModel> dataSource;
  SumOfElectricityConsumptionDataSource({required this.dataSource});

  @override
  List<DataGridRow> get rows => dataSource
    .map<DataGridRow>(SumConsumptionTableConfig.getRows)
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