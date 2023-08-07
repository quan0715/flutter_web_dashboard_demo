
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';

class ElectricityConsumptionDashboardViewModel extends ChangeNotifier{
  bool isLoading = false;
  String targetFactoryId = "G1";
  String targetBuildingId = "全";
  String targetAssetType = "全";
  DateTime targetDateTime = DateTime.now();

  bool isShowErrorOnly = true; 
  bool isDashboardView = true;

  List<ElectricityConsumptionDataModel> _electricityConsumptionDataList = [];
  List<SumOfElectricityConsumptionDataModel> _sumOfElectricityConsumptionDataList = [];
  // List<SumOfElectricityConsumptionDataModel> _weaklySumOfElectricityConsumptionDataList = [];
  ElasticSearchClient<ElectricityConsumptionDataModel> client = ElasticSearchClient.fromModel(ElectricityConsumptionDataModel.getInstance());
  ElasticSearchClient<SumOfElectricityConsumptionDataModel> sumClient = ElasticSearchClient.fromModel(SumOfElectricityConsumptionDataModel.getInstance());

  List<String> factoryList = ["G1", "G2", "G3"];
  List<String> buildingList = ["全", "M1", "M2", "M3"];
  List<String> assetTypeList = [];
  List<DateTime> dateTimeList = [];

  List<ElectricityConsumptionDataModel> get electricityConsumptionDataList => _electricityConsumptionDataList;
  List<SumOfElectricityConsumptionDataModel> get sumOfElectricityConsumptionDataList => 
    _sumOfElectricityConsumptionDataList.where(deviceFilter).toList();
  
  List<SumOfElectricityConsumptionDataModel> get weaklySumOfElectricityConsumptionDataList{
    final int startIndex = dateTimeList.indexOf(targetDateTime);
    final int endIndex = startIndex + 7 < dateTimeList.length ? startIndex + 7: dateTimeList.length;
    final dayList = dateTimeList.sublist(startIndex, endIndex);
    // count accumulate data
    debugPrint(dayList.toString());
    
    return dayList.map<SumOfElectricityConsumptionDataModel>((date) => 
        SumOfElectricityConsumptionDataModel(
          dateTime: date,
          dayConsumption: _sumOfElectricityConsumptionDataList.where((element) => element.dateTime == date).map<int>((e) => e.dayConsumption!).reduce((value, element) => value + element),
          loc: targetFactoryId,
          building: targetBuildingId,
        )
      ).toList();
  } 

  bool deviceFilter(SumOfElectricityConsumptionDataModel element) => 
    element.loc == targetFactoryId 
    && (element.building == targetBuildingId || targetBuildingId == "全")
    && (element.dateTime! == targetDateTime)
    && (element.assetType == targetAssetType || targetAssetType == "全");

  set setTargetFactoryId(String id){
    targetFactoryId = id;
    notifyListeners();
  }

  set setTargetBuildingId(String id){
    targetBuildingId = id;
    notifyListeners();
  }

  set setTargetDateTime(DateTime dateTime){
    targetDateTime = dateTime;
    notifyListeners();
  }

  set setTargetAssetType(String assetType){
    targetAssetType = assetType;
    notifyListeners();
  }

  set setIsShowAll(bool value){
    // if isShowAll is true, then show all the data
    // otherwise, show the device data which is not normal or with error report 
    isShowErrorOnly = value;
    notifyListeners();
  }

  set setIsDashboard(bool value){
    // if isDashboard is true then show the dashboard,
    // otherwise, show the table view
    isDashboardView = value;
    notifyListeners();
  }
  
  Future<void> init() async{
    isLoading = true;
    notifyListeners();
    // load data from repo
    _electricityConsumptionDataList = await client.search();
    _sumOfElectricityConsumptionDataList = await sumClient.search();
    // debugPrint(_electricityConsumptionDataList.length.toString());
    // debugPrint(_sumOfElectricityConsumptionDataList.length.toString());
    _sumOfElectricityConsumptionDataList.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    
    // set dashboard dropdown menu list 
    factoryList = _sumOfElectricityConsumptionDataList.map<String>((data) => data.loc!).toSet().toList();
    buildingList = _sumOfElectricityConsumptionDataList.map<String>((data) => data.building!).toSet().toList()..insert(0, "全");
    dateTimeList = _sumOfElectricityConsumptionDataList.map<DateTime>((data) => data.dateTime!).toSet().toList();
    assetTypeList = _sumOfElectricityConsumptionDataList.map<String>((data) => data.assetType!).toSet().toList()..insert(0, "全");
    
    // targetDateTime = dateTimeList.first;
    targetDateTime = dateTimeList.reduce((value, element) => 
      (value.difference(targetDateTime).inDays.abs() < element.difference(targetDateTime).inDays.abs()) ? value : element
    );
    
    targetFactoryId = factoryList.first;
    targetBuildingId = buildingList.first;
    // debugPrint(result.length. toString());
    isLoading = false;
    notifyListeners();
  }
}
