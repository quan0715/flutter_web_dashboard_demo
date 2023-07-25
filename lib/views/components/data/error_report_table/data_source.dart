import 'package:flutter/material.dart';
import 'package:web_dashboard/models/error_report_model.dart';
import 'package:web_dashboard/theme/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AmmeterGridDataSource extends DataGridSource {
  List<AmmeterErrorReportModel> dataSource;

  AmmeterGridDataSource({required  this.dataSource});
  @override
  List<DataGridRow> get rows => dataSource
      .map<DataGridRow>((dataRow) => DataGridRow(cells: [
            DataGridCell<String>(columnName: '設備編號', value: dataRow.ammeter.ammeterId),
            DataGridCell<String>(columnName: '設備名稱', value: dataRow.ammeter.name),
            DataGridCell<String>(columnName: '發生時間', value: DashBoardFormat.time(dataRow.startTime)),
            DataGridCell<String>(columnName: '正常數值', value: DashBoardFormat.number(dataRow.averageElectricityConsumed)),
            DataGridCell<String>(columnName: '異常異常', value: DashBoardFormat.number(dataRow.electricityConsumed)),
            DataGridCell<String>(columnName: '異常狀態', value: dataRow.getErrorType()),
          ]))
      .toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
          if(dataCell.columnName == '異常狀態'){
            if(dataCell.value == '突增'){
              return const Center(
                child: RawChip(
                  avatar: Icon(Icons.trending_up, color: Colors.amber),
                  label:const Text('突增')
                ),
              );
            }else if(dataCell.value == '突降'){
              return const Center(
                child: RawChip(
                  avatar: Icon(Icons.trending_down, color: Colors.red),
                  label:const Text('突降')
                ),
              );
            }
          }
          // if(dataCell.columnName == "異常時間"){
          //   return Center(child: Text(DashBoardFormat.dayTime((dataCell.value))));
          // }
          return Center(child: Text(dataCell.value.toString()));
        }).toList());
  }
}