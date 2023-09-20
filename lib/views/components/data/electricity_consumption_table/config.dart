import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/views/theme/format.dart';

class ConsumptionTableConfig{
  static DataGridRow getRows(ElectricityConsumptionDataModel data){
    return DataGridRow(cells: [
      // DataGridCell<String>(columnName: '工廠', value: data.deviceData!.loc),
      // DataGridCell<String>(columnName: '區域', value: data.deviceData!.building),
      // DataGridCell<String>(columnName: '設備設備', value: data.deviceData!.assetType),
      // DataGridCell<String>(columnName: '設備產線', value: data.deviceData!.lineType),
      DataGridCell<String>(columnName: '設備編號', value: data.deviceData!.tagId),
      DataGridCell<String>(columnName: '耗電(KW)', value: data.power.toString()),
      // DataGridCell<String>(columnName: '電壓', value: data.volt.toString()),
      // DataGridCell<String>(columnName: '電流', value: data.ampere.toString()),
      DataGridCell<String>(columnName: '耗電量', value: data.energyConsumed.toString()),
      DataGridCell<String>(columnName: '總耗電量', value: data.sumOfEnergyConsumed.toString()),
      DataGridCell<String>(columnName: '電費費率', value: data.priceRate.toString()),
      DataGridCell<String>(columnName: '總電費', value: data.billPrice!.round().toString()),
      DataGridCell<String>(columnName:  "Ub", value: data.boundData!.upperBound.toString()),
      DataGridCell<String>(columnName:  "Lb", value: data.boundData!.lowerBound.toString()),
      DataGridCell<String>(columnName:  "WUb", value: data.boundData!.warningUpperBound.toString()),
      DataGridCell<String>(columnName:  "WLb", value: data.boundData!.warningLowerBound.toString()),
      DataGridCell<String>(columnName: '更新時間', value: DashBoardFormat.timeWithSecond(data.recordTime!)),
    ]);
  }
  static List<String> columName = [
    // '工廠',
    // '區域',
    //  '設備設備',
    // '設備產線',
    '設備編號',
    '耗電(KW)',
     // '電壓',
     // '電流',
    '耗電量',
    '總耗電量',
    '電費費率',
    '總電費',
    "Ub",
    "Lb",
    "WUb",
    "WLb",
    '更新時間',
  ];
}
