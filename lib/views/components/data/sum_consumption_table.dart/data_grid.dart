
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/components/data/sum_consumption_table.dart/config.dart';
import 'package:web_dashboard/views/components/data/sum_consumption_table.dart/data_source.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class SumOfElectricityConsumptionDataGrid extends StatelessWidget{
  final List<SumOfElectricityConsumptionDataModel> dataSource;
  final bool priceOnly;
  late final DataGridSource? dataGridSource;
  late final List<String> columnsLabel;
  SumOfElectricityConsumptionDataGrid({super.key, required this.dataSource, this.priceOnly = false}){
    dataGridSource = SumOfElectricityConsumptionDataSource(dataSource: dataSource, priceOnly: priceOnly);
    columnsLabel = priceOnly ? SumConsumptionTableBillOnlyConfig.columNameList : SumConsumptionTableConfig.columNameList;
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
        columnWidthMode: MediaQuery.sizeOf(context).width > 1200 ? ColumnWidthMode.fill : ColumnWidthMode.auto,
        source: dataGridSource!,
        columns: columnsLabel.map((label) => GridColumn(
          columnName: label,
          label: Container(
            color: priceOnly ? Colors.green.withOpacity(0.1) : DashboardColor.primary(context).withOpacity(0.2),
            child: Center(
              child: Text(label),
            ),
          ),
        )).toList()
      ),
    );
  }
}