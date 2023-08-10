import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/theme/format.dart';

class SumConsumptionTableConfig{
  static DataGridRow getRows(SumOfElectricityConsumptionDataModel data){
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: '設備編號', value: data.deviceData!.tagId),
      DataGridCell<String>(columnName: '工廠', value: data.deviceData!.loc),
      DataGridCell<String>(columnName: '區域', value: data.deviceData!.building),
      DataGridCell<String>(columnName: '設備類型', value: data.deviceData!.assetType),
      DataGridCell<String>(columnName: '日累累積電量', value: data.dayConsumption.toString()),
      DataGridCell<String>(columnName: '月累累積電量', value: data.monthConsumption.toString()),
      DataGridCell<String>(columnName: '季累積電量', value: data.quarterConsumption.toString()),
      DataGridCell<String>(columnName: '年累積電量', value: data.yearConsumption.toString()),
      DataGridCell<String>(columnName: '月平均小時耗電量', value: data.averageMonthConsumptionPerMonth.toString()),
      DataGridCell<String>(columnName: '監測時間', value: DashBoardFormat.timeWithSecond(data.dateTime!)),
    ]);
  }
  static List<String> columNameList = [
    '設備編號',
    '工廠',
    '區域',
    '設備類型',
    '日累累積電量',
    '月累累積電量',
    '季累積電量',
    '年累積電量',
    '月平均小時耗電量',
    '監測時間',
  ];
}