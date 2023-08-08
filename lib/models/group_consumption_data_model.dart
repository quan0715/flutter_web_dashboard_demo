// Purpose: GroupConsumptionDataModel model class definition
// Usage: Represent the data model for group of consumption data
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';

class GroupConsumptionDataModel {
  final List<SumOfElectricityConsumptionDataModel> dataSource;
  // SumOfElectricityConsumptionDataModel? data;
  int totalConsumptionOfMonth = 0;
  int totalConsumptionOfToday = 0;
  double totalConsumptionOfMonthPerHour = 0;
  List<String> factoryList = ["全"];
  List<String> buildingList = ["全"];
  List<String> assetTypeList = ["全"];
  List<DateTime> dateTimeList = [];
  GroupConsumptionDataModel({required this.dataSource}){
    initData();
  }
  factory GroupConsumptionDataModel.fromDataSource(List<SumOfElectricityConsumptionDataModel> dataSource) => GroupConsumptionDataModel(dataSource: dataSource);
  void initData(){
    if(dataSource.isNotEmpty){
      totalConsumptionOfMonth = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.monthConsumption!);
      totalConsumptionOfToday = dataSource.fold<int>(0, (previousValue, element) => previousValue + element.dayConsumption!);
      totalConsumptionOfMonthPerHour = dataSource.fold<double>(0, (previousValue, element) => previousValue + element.averageMonthConsumptionPerMonth!);
      
      factoryList.addAll(dataSource.map<String>((e) => e.loc!).toSet().toList());
      buildingList.addAll(dataSource.map<String>((e) => e.building!).toSet().toList());
      assetTypeList.addAll(dataSource.map<String>((e) => e.assetType!).toSet().toList());
      dateTimeList.addAll(dataSource.map<DateTime>((e) => e.dateTime!).toSet().toList());
    }
  }
}