
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/config.dart';

class DeviceErrorReportTableDataSource extends DataGridSource{
  final List<DeviceErrorReportModel> dataSource;
  final bool isLarge ;
  
  DeviceErrorReportTableDataSource({required this.dataSource, this.isLarge = true});

  @override
  List<DataGridRow> get rows => dataSource
    .map<DataGridRow>(
      isLarge ? LargeViewDeviceErrorReportTableConfig.getRows : SmallViewDeviceErrorReportTableConfig.getRows
    ).toList();

  Widget errorTypeLabel(ElectricityConsumptionErrorType errorType){
    return RawChip(
      side: BorderSide.none,
      label: Text(errorType.label),
      avatar: Icon(errorType.icon, color: errorType.iconsColor,), 
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataCell){
      if(dataCell.columnName == "異常類別"){
        return errorTypeLabel(ElectricityConsumptionErrorType.fromLabel(dataCell.value));
      }
      return Align(
        alignment: Alignment.center,
        child: Text(dataCell.value.toString())
      );
    }).toList()
    );
  }
}