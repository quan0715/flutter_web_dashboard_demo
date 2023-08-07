
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_source.dart';

class ElectricityConsumptionDataGrid extends StatelessWidget{
  final List<ElectricityConsumptionDataModel> dataSource;
  late final DataGridSource? dataGridSource;
  late final List<String> columnsLabel;
  ElectricityConsumptionDataGrid({super.key, required this.dataSource}){
    dataGridSource = ElectricityConsumptionDataSource(dataSource: dataSource);
    columnsLabel =  dataGridSource!.rows[0].getCells().map<String>((dataCell) => dataCell.columnName).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: 
      dataSource.isEmpty ? 
      const Center(
        child: Text("無資料"),
      ) :
      SfDataGrid(
        allowPullToRefresh: true,
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