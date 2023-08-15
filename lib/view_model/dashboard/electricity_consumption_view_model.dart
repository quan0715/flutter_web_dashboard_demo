import 'package:flutter/material.dart';
import 'package:web_dashboard/models/group_consumption_data_model.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/device_data_class.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class ElectricityConsumptionDashboardViewModel extends BaseViewModel {
  bool isShowErrorOnly = true; 
  bool isDashboardView = true;
  DateTime targetDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String targetGroupType = "全";

  List<String> groupType = [
    "全", // 整場
    "樓層", // building
    "設備類型", // asset type 
    "用電部門", // department
    "產線類型"  // line type
  ]; 

  // DeviceGroupModel? _allDeviceConsumptionDataGroup; // Sum of consumption data without filter (from repo)
  List<ElectricityConsumptionDataModel> _electricityConsumptionDataList = [];
  List<SumOfElectricityConsumptionDataModel> _sumOfElectricityConsumptionDataList = [];
  List<SumOfElectricityConsumptionDataModel> _lastWeakSumOfElectricityConsumptionDataList = [];
  List<SumOfElectricityConsumptionDataModel> _weaklySumOfElectricityConsumptionDataList = [];
  List<DeviceErrorReportModel> _deviceErrorReportList = [];
  List<MonitoringDeviceModel> _deviceList = [];
  List<String> _deviceIndexList = [];

  // elastic search client for ElectricityConsumptionDataModel
  ElasticSearchClient<ElectricityConsumptionDataModel> consumptionClient = 
    ElasticSearchClient.fromModel(ElectricityConsumptionDataModel.getInstance());

  // elastic search client for SumOfElectricityConsumptionDataModel
  ElasticSearchClient<SumOfElectricityConsumptionDataModel> sumOfConsumptionClient = 
    ElasticSearchClient.fromModel(SumOfElectricityConsumptionDataModel.getInstance());

  // elastic search client for DeviceErrorReportModel
  ElasticSearchClient<DeviceErrorReportModel> errorReportClient = 
    ElasticSearchClient.fromModel(DeviceErrorReportModel.getInstance());

  // elastic search device data client
  ElasticSearchClient<MonitoringDeviceModel> deviceClient = 
    ElasticSearchClient.fromModel(MonitoringDeviceModel.getInstance());

  List<DeviceErrorReportModel> get deviceErrorReportList => _deviceErrorReportList;

  List<ElectricityConsumptionDataModel> get electricityConsumptionDataList => _electricityConsumptionDataList;
  
  List<SumOfElectricityConsumptionDataModel> get sumOfElectricityConsumptionDataList => _sumOfElectricityConsumptionDataList;
  
  List<SumOfElectricityConsumptionDataModel> get getGroupDataSource {
    List<SumOfElectricityConsumptionDataModel> groupDataSource = [];
    if (targetGroupType == "全"){
      groupDataSource = _sumOfElectricityConsumptionDataList.map<DeviceGroupModel>((e) => DeviceGroupModel(groupLabel: e.deviceData!.tagId, dataSource: [e])).toList();
    }else if (targetGroupType == "樓層"){
      final buildingList = _sumOfElectricityConsumptionDataList.map<String>((e) => e.deviceData!.building!).toSet().toList();
      for(String building in buildingList){
        groupDataSource.add(
          DeviceGroupModel(
            groupLabel: building,
            dataSource: _sumOfElectricityConsumptionDataList.where((element) => element.deviceData!.building == building).toList()
          )
        );
      }

      // debugPrint("group: $groupDataSource");
    }else if(targetGroupType == "設備類型"){
      final assetTypeList = _sumOfElectricityConsumptionDataList.map<String>((e) => e.deviceData!.assetType!).toSet().toList();
      for(String assetType in assetTypeList){
        groupDataSource.add(
          DeviceGroupModel(
            groupLabel: assetType,
            dataSource: _sumOfElectricityConsumptionDataList.where((element) => element.deviceData!.assetType == assetType).toList()
          )
        );
      }
    }else if(targetGroupType == "用電部門"){
      final departmentList = _sumOfElectricityConsumptionDataList.map<String>((e) => e.deviceData!.department!).toSet().toList();
      for(String department in departmentList){
        groupDataSource.add(
          DeviceGroupModel(
            groupLabel: department,
            dataSource: _sumOfElectricityConsumptionDataList.where((element) => element.deviceData!.department == department).toList()
          )
        );
      }
    }else if(targetGroupType == "產線類型"){
      final lineTypeList = _sumOfElectricityConsumptionDataList.map<String>((e) => e.deviceData!.lineType!).toSet().toList();
      for(String lineType in lineTypeList){
        groupDataSource.add(
          DeviceGroupModel(
            groupLabel: lineType,
            dataSource: _sumOfElectricityConsumptionDataList.where((element) => element.deviceData!.lineType == lineType).toList()
          )
        );
      }
    }
    debugPrint(groupDataSource.first.groupLabel);
    return groupDataSource;
  }

  SumOfElectricityConsumptionDataModel get getOverAllData{
    return DeviceGroupModel(
      groupLabel: targetGroupType,
      dataSource: getGroupDataSource
    );
  }  

  // List<SumOfElectricityConsumptionDataModel> getTimeGroup

  List<SumOfElectricityConsumptionDataModel> timeGroupDataSource(List<SumOfElectricityConsumptionDataModel> data){
    var dateList = data.map((e) => e.dateTime!).toSet().toList();
     return dateList.map<SumOfElectricityConsumptionDataModel>((date) => 
        DeviceGroupModel(
          groupLabel: DashBoardFormat.dateTime(date),
          dataSource: data.where((element) => element.dateTime == date).toList(),
        )
      ).toList();
  }

  List<SumOfElectricityConsumptionDataModel> get weaklySumOfElectricityConsumptionDataList 
    => timeGroupDataSource(_weaklySumOfElectricityConsumptionDataList);
  
  List<SumOfElectricityConsumptionDataModel> get lastWeakSumOfElectricityConsumptionDataList
    => timeGroupDataSource(_lastWeakSumOfElectricityConsumptionDataList);

  set setTargetDateTime(DateTime dateTime){
    targetDateTime = dateTime;
    init();
    // notifyListeners();
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
  
  set setGroupType(String value){
    targetGroupType = value;
    
    notifyListeners();
  }
 
  Future<List<SumOfElectricityConsumptionDataModel>> getSumConsumptionDataByTime(DateTime startTime, DateTime endTime, String? tagId) async{
    final query = {
      "size": 9999,
      "query": {
        "bool": {
          "must": [
            {
              "match": {"tagid" : tagId},
            },
            {
              "range": {
                "datetime": {
                  "time_zone": "+08:00",
                  "gte": startTime.toIso8601String(),
                  "lte": endTime.toIso8601String()
                }
              }
            }
          ]
        }
      },
      "sort": [{"datetime": {"order": "asc"}},
      ],
    };
    return await sumOfConsumptionClient.search(query: query);
  }
  
  @override
  Future<void> init() async{
    _weaklySumOfElectricityConsumptionDataList = [];
    _sumOfElectricityConsumptionDataList = [];
    _lastWeakSumOfElectricityConsumptionDataList = [];
    _deviceErrorReportList = [];
    _deviceList = [];
    _deviceIndexList = [];
    setGroupType = groupType.first;
    setLoadingState(LoadingState.loading);
    final query = {
          "sort": [
            {
              "datetime": {
                "order": "desc"
              }
            } 
          ],
        };
    try{
      // get device list and index 
      _deviceList = await deviceClient.search();
      _deviceIndexList = _deviceList.map((e) => e.device?.tagId ?? "").toSet().toList();
      _electricityConsumptionDataList = await consumptionClient.search(query: query);

      for(String? tagId in _deviceIndexList){
        // getSumConsumptionDataByTime
        var result = await getSumConsumptionDataByTime(
          targetDateTime.subtract(const Duration(days: 6)), 
          targetDateTime.add(const Duration(hours: 23, minutes: 59)),
          tagId
        );
        if(result.isNotEmpty){
          _sumOfElectricityConsumptionDataList.add(result.last);
          _weaklySumOfElectricityConsumptionDataList.addAll(result);
        }else{
          debugPrint("no device data for $tagId");
        }
        result = await getSumConsumptionDataByTime(
          targetDateTime.subtract(const Duration(days: 13)), 
          targetDateTime.subtract(const Duration(days: 6)),
          tagId
        );
        if(result.isNotEmpty){
          _lastWeakSumOfElectricityConsumptionDataList.addAll(result);
        }else{
          debugPrint("no device data for $tagId");
        }
      }
      _deviceErrorReportList = await errorReportClient.search();
      debugPrint("deviceErrorReport Number: ${_deviceErrorReportList.length}");
    }catch(e){
      debugPrint(e.toString());
      setLoadingState(LoadingState.error);
    }
    setLoadingState(LoadingState.free);
  }
}
