import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/theme/theme.dart';


class SumOfElectricityConsumptionDataSource extends DataGridSource{
  List<SumOfElectricityConsumptionDataModel> dataSource;
  SumOfElectricityConsumptionDataSource({required this.dataSource});

  @override
  List<DataGridRow> get rows => dataSource
    .map<DataGridRow>((data) => DataGridRow(cells: [
      DataGridCell<String>(columnName: '設備編號', value: data.tagId),
      DataGridCell<String>(columnName: '工廠', value: data.loc),
      DataGridCell<String>(columnName: '區域', value: data.building),
      DataGridCell<String>(columnName: '設備類型', value: data.assetType),
      DataGridCell<String>(columnName: '日累積耗電量', value: data.dayConsumption.toString()),
      DataGridCell<String>(columnName: '月累積耗電量', value: data.monthConsumption.toString()),
      DataGridCell<String>(columnName: '月平均小時耗電量', value: data.averageMonthConsumptionPerMonth.toString()),
      DataGridCell<String>(columnName: '監測時間', value: DashBoardFormat.timeWithSecond(data.dateTime!)),
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