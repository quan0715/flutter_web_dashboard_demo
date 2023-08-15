// Purpose: GroupConsumptionDataModel model class definition
// Usage: Represent the data model for group of consumption data
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';

class DeviceGroupModel extends SumOfElectricityConsumptionDataModel{ 
  final List<SumOfElectricityConsumptionDataModel> dataSource;
  
  DeviceGroupModel({required this.dataSource, required groupLabel}){
    super.groupLabel = groupLabel;
    initData();
  }
  // factory DeviceGroupModel.fromDataSource(List<SumOfElectricityConsumptionDataModel> dataSource) 
  // => DeviceGroupModel(dataSource: dataSource);
  
  void initData(){
    if(dataSource.isNotEmpty){
      dayConsumption = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.dayConsumption!);
      monthConsumption = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.monthConsumption!);
      yearConsumption = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.yearConsumption!);
      quarterConsumption = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.quarterConsumption!);
      averageMonthConsumptionPerMonth = dataSource.fold<double>(0, (previousValue, element) => previousValue + element.averageMonthConsumptionPerMonth!);
      // factoryList.addAll(dataSource.map<String>((e) => e.deviceData!.loc!).toSet().toList());
      // buildingList.addAll(dataSource.map<String>((e) => e.deviceData!.building!).toSet().toList());
      // assetTypeList.addAll(dataSource.map<String>((e) => e.deviceData!.assetType!).toSet().toList());
      // dateTimeList.addAll(dataSource.map<DateTime>((e) => e.dateTime!).toSet().toList());
    }
  }

  @override
  String toString() {
    return 'DeviceGroupModel{dataSource: $dataSource}\n groupLabel: $groupLabel';
  }
}