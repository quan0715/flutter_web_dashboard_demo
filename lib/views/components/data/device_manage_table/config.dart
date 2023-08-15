

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';
import 'package:web_dashboard/views/theme/format.dart';

class DeviceManageTableConfig{
  static DataGridRow getRows(MonitoringDeviceModel data){
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: '工廠', value: data.device?.loc ?? "" ),
      DataGridCell<String>(columnName: '區域', value: data.device?.building ?? ""),
      DataGridCell<String>(columnName: '設備編號', value: data.device?.tagId ?? ""),
      DataGridCell<String>(columnName: '設備類型', value: data.device?.assetType ?? ""),
      DataGridCell<String>(columnName: '產線類型', value: data.device?.lineType ?? ""),
      DataGridCell<String>(columnName: '用電部門', value: data.device?.department ?? ""),
      DataGridCell<String>(columnName:  "Ub", value: data.boundData?.upperBound.toString() ?? "-1"),
      DataGridCell<String>(columnName:  "Lb", value: data.boundData?.lowerBound.toString() ?? "-1"),
      DataGridCell<String>(columnName: "WUb", value: data.boundData?.warningUpperBound.toString() ?? "-1"),
      DataGridCell<String>(columnName: "WLb", value: data.boundData?.warningLowerBound.toString() ?? "-1"),
      DataGridCell<String>(columnName: '修改者', value: data.changeBy ?? ""),
      DataGridCell<String>(columnName: '修改時間', value: DashBoardFormat.time(data.changeDate!)),
    ]);
  }
  static List<String> columName = [
     "工廠", "區域", "設備編號", "設備類型","產線類型","用電部門","Ub","Lb","WUb","WLb" ,"修改者", "修改時間"
  ];
}