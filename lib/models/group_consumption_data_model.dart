// Purpose: GroupConsumptionDataModel model class definition
// Usage: Represent the data model for group of consumption data
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';

class DeviceGroupModel extends SumOfElectricityConsumptionDataModel{ 
  final List<SumOfElectricityConsumptionDataModel> dataSource;
  // bool isSingleDevice = false;

  
  DeviceGroupModel({required this.dataSource, required groupLabel}){
    super.groupLabel = groupLabel;
    initData();
  }
  
  void initData(){
    if(dataSource.isNotEmpty){
      dayConsumption = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.dayConsumption!);
      monthConsumption = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.monthConsumption!);
      yearConsumption = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.yearConsumption!);
      quarterConsumption = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.quarterConsumption!);
      averageMonthConsumptionPerMonth = dataSource.fold<double>(0, (previousValue, element) => previousValue + element.averageMonthConsumptionPerMonth!);
    }
  }

  @override
  String toString() {
    return 'groupLabel: $groupLabel\nDeviceGroupModel{dataSource: $dataSource}\n';
  }

}