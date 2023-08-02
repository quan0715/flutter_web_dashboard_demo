
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_source.dart';

class ElectricityConsumptionDataGrid extends StatelessWidget{
  final List<ElectricityConsumptionDataModel> dataSource;
  ElectricityConsumptionDataGrid({super.key, required this.dataSource});
  final columnsLabel = [
    "工廠", "區域", "耗電", "電壓", "電流", "耗電量", "總耗電量", "更新時間"
  ];
  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      allowPullToRefresh: true,
      gridLinesVisibility: GridLinesVisibility.vertical,
      headerGridLinesVisibility: GridLinesVisibility.vertical,
      columnWidthMode: ColumnWidthMode.fill,
      source: ElectricityConsumptionDataSource(dataSource: dataSource),
      columns: columnsLabel.map((label) => GridColumn(
        columnName: label,
        label: Container(
          color: Colors.amber.withOpacity(0.5),
          child: Center(
            child: Text(label),
          ),
        ),
      )).toList()
    );
  }
}