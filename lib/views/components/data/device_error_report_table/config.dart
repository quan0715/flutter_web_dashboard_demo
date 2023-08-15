import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/views/theme/format.dart';

class LargeViewDeviceErrorReportTableConfig{
  static DataGridRow getRows(DeviceErrorReportModel data){
    return DataGridRow(cells: [
      DataGridCell(columnName: "異常類別", value: data.errorType?.label ?? "無"),
      DataGridCell(columnName: "開始時間", value: DashBoardFormat.time(data.startTime!)),
      DataGridCell(columnName: "位置", value: data.loc),
      DataGridCell(columnName: "建築物", value: data.building),
      DataGridCell(columnName: "設備編號", value: data.tagId),
      DataGridCell(columnName: "當下電流", value: data.ampere),
      DataGridCell(columnName: "當下電壓", value: data.voltage),
      DataGridCell(columnName: "當下功率", value: data.power),
      DataGridCell(columnName: "Ub", value: data.boundData?.upperBound ?? "-1"),
      DataGridCell(columnName: "Lb", value: data.boundData?.lowerBound ?? "-1"),
      DataGridCell(columnName: "WUb", value: data.boundData?.warningUpperBound ?? "-1"),
      DataGridCell(columnName: "WLb", value: data.boundData?.warningLowerBound ?? "-1"),
    ]);
  }
  static List<String> columName = [
    "異常類別",
    "開始時間", 
    "位置",
    "建築物",
    "設備編號",
    "當下電流",
    "當下電壓",
    "當下功率", 
    "Ub",
    "Lb",
    "WUb",
    "WLb"
  ];
}

class SmallViewDeviceErrorReportTableConfig{
  static DataGridRow getRows(DeviceErrorReportModel data){
    return DataGridRow(cells: [
      DataGridCell(columnName: "異常類別", value: data.errorType?.label ?? "無"),
      // DataGridCell(columnName: "位置", value: data.loc),
      // DataGridCell(columnName: "建築", value: data.building),
      DataGridCell(columnName: "開始時間", value: DashBoardFormat.time(data.startTime!)),
      DataGridCell(columnName: "當下電流", value: data.ampere),
      DataGridCell(columnName: "當下電壓", value: data.voltage),
      DataGridCell(columnName: "當下功率", value: data.power),
      DataGridCell(columnName: "Ub", value: data.boundData?.upperBound ?? "-1"),
      DataGridCell(columnName: "Lb", value: data.boundData?.lowerBound ?? "-1"),
      DataGridCell(columnName: "WUb", value: data.boundData?.warningUpperBound ?? "-1"),
      DataGridCell(columnName: "WLb", value: data.boundData?.warningLowerBound ?? "-1"),
    ]);
  }
  static List<String> columName = [
    // "位置",
    // "建築",
    "異常類別",
    "開始時間", 
    "當下電流",
    "當下電壓",
    "當下功率", 
    "WUb",
    "WLb",
    "UB",
    "LB"
  ];
}