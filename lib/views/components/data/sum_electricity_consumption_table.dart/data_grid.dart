
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/components/data/sum_electricity_consumption_table.dart/data_source.dart';

class SumOfElectricityConsumptionDataGrid extends StatelessWidget{
  final List<SumOfElectricityConsumptionDataModel> dataSource;
  late final DataGridSource? dataGridSource;
  late final List<String> columnsLabel;
  SumOfElectricityConsumptionDataGrid({super.key, required this.dataSource}){
    dataGridSource = SumOfElectricityConsumptionDataSource(dataSource: dataSource);
    columnsLabel =  dataGridSource!.rows[0].getCells().map<String>((dataCell) => dataCell.columnName).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      child: 
      dataSource.isEmpty ? 
      const Center(
        child: Text("無資料"),
      ) :
      SfDataGrid(
        allowPullToRefresh: true,
        showFilterIconOnHover: true,
        gridLinesVisibility: GridLinesVisibility.vertical,
        headerGridLinesVisibility: GridLinesVisibility.vertical,
        columnWidthMode: ColumnWidthMode.fill,
        source: dataGridSource!,
        columns: columnsLabel.map((label) => GridColumn(
          columnName: label,
          label: Container(
            color: Colors.amber.withOpacity(0.1),
            child: Center(
              child: Text(label),
            ),
          ),
        )).toList()
      ),
    );
  }
}