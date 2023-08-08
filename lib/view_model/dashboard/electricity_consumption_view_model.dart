import 'package:flutter/material.dart';
import 'package:web_dashboard/models/group_consumption_data_model.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';


class ElectricityConsumptionDashboardViewModel extends BaseViewModel {
  bool isShowErrorOnly = true; 
  bool isDashboardView = true;
  String targetFactoryId = "G1";
  String targetBuildingId = "全";
  String targetAssetType = "全";
  DateTime targetDateTime = DateTime.now();

  GroupConsumptionDataModel? _allDeviceConsumptionDataGroup; // Sum of consumption data without filter (from repo)
  List<ElectricityConsumptionDataModel> _electricityConsumptionDataList = [];
  List<SumOfElectricityConsumptionDataModel> _sumOfElectricityConsumptionDataList = [];
  List<DeviceErrorReportModel> _deviceErrorReportList = [];

  // elastic search client for ElectricityConsumptionDataModel
  ElasticSearchClient<ElectricityConsumptionDataModel> consumptionClient = 
    ElasticSearchClient.fromModel(ElectricityConsumptionDataModel.getInstance());

  // elastic search client for SumOfElectricityConsumptionDataModel
  ElasticSearchClient<SumOfElectricityConsumptionDataModel> sumOfConsumptionClient = 
    ElasticSearchClient.fromModel(SumOfElectricityConsumptionDataModel.getInstance());

  // elastic search client for DeviceErrorReportModel
  ElasticSearchClient<DeviceErrorReportModel> errorReportClient = 
    ElasticSearchClient.fromModel(DeviceErrorReportModel.getInstance());

  List<String> get factoryList => _allDeviceConsumptionDataGroup?.factoryList ?? [];
  List<String> get buildingList => _allDeviceConsumptionDataGroup?.buildingList ?? [];
  List<String> get assetTypeList => _allDeviceConsumptionDataGroup?.assetTypeList ?? [];
  List<DateTime> get dateTimeList => _allDeviceConsumptionDataGroup?.dateTimeList ?? [];

  List<DeviceErrorReportModel> get deviceErrorReportList => _deviceErrorReportList;

  List<ElectricityConsumptionDataModel> get electricityConsumptionDataList 
    => _electricityConsumptionDataList;
  
  List<SumOfElectricityConsumptionDataModel> get sumOfElectricityConsumptionDataList
    => _sumOfElectricityConsumptionDataList.where(deviceFilter).toList();

  GroupConsumptionDataModel get groupDataSource => 
    GroupConsumptionDataModel.fromDataSource(sumOfElectricityConsumptionDataList);
  
  List<SumOfElectricityConsumptionDataModel> get weaklySumOfElectricityConsumptionDataList{
    final startTime = targetDateTime;
    final endTime = startTime.add(const Duration(days: 8));
    var filterData = _sumOfElectricityConsumptionDataList.where((element) => 
      element.dateTime!.isAfter(startTime) && element.dateTime!.isBefore(endTime)
    ).toList();
    var dateList = filterData.map((e) => e.dateTime!).toSet().toList();
    return dateList.map<SumOfElectricityConsumptionDataModel>((date) => 
        SumOfElectricityConsumptionDataModel(
          dateTime: date,
          dayConsumption: _sumOfElectricityConsumptionDataList.where((element) => element.dateTime == date).map<int>((e) => e.dayConsumption!).reduce((value, element) => value + element),
          loc: targetFactoryId,
          building: targetBuildingId,
        )
      ).toList();
  } 

  bool deviceFilter(SumOfElectricityConsumptionDataModel element) => 
    (element.loc == targetFactoryId || targetFactoryId == "全")
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
  
  @override
  Future<void> init() async{
    setLoadingState(LoadingState.loading);

    try{
      _electricityConsumptionDataList = await consumptionClient.search();
      _sumOfElectricityConsumptionDataList = await sumOfConsumptionClient.search();
      _deviceErrorReportList = await errorReportClient.search();
    }catch(e){
      debugPrint(e.toString());
      setLoadingState(LoadingState.error);
    }
    
    _sumOfElectricityConsumptionDataList.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    _allDeviceConsumptionDataGroup = GroupConsumptionDataModel.fromDataSource(_sumOfElectricityConsumptionDataList);

    targetDateTime = dateTimeList.reduce((value, element) => 
      (value.difference(targetDateTime).inDays.abs() < element.difference(targetDateTime).inDays.abs()) ? value : element
    );

    targetFactoryId = factoryList.first;
    targetBuildingId = buildingList.first;

    setLoadingState(LoadingState.free);
  }
}
