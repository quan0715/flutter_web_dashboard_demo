
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/config.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_source.dart';
import 'package:web_dashboard/views/theme/color.dart';

class ElectricityConsumptionDataGrid extends StatelessWidget{
  final List<ElectricityConsumptionDataModel> dataSource;
  late final DataGridSource? dataGridSource;
  late final List<String> columnsLabel;
  ElectricityConsumptionDataGrid({super.key, required this.dataSource}){
    dataGridSource = ElectricityConsumptionDataSource(dataSource: dataSource);
    columnsLabel = ConsumptionTableConfig.columName;
    // columnsLabel =  dataGridSource!.rows[0].getCells().map<String>((dataCell) => dataCell.columnName).toList();
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
        horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
        // isScrollbarAlwaysShown: true,
        gridLinesVisibility: GridLinesVisibility.vertical,
        headerGridLinesVisibility: GridLinesVisibility.vertical,
        columnWidthMode: MediaQuery.sizeOf(context).width > 1200 ? ColumnWidthMode.fill : ColumnWidthMode.auto,
        source: dataGridSource!,
        columns: columnsLabel.map((label) => GridColumn(
          columnName: label,
          label: Container(
            color: DashboardColor.primary(context).withOpacity(0.2),
            child: Center(
              child: Text(label),
            ),
          ),
        )).toList()
      ),
    );
  }
}