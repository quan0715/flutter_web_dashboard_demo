import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/group_consumption_data_model.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search_tree.dart';
import 'package:web_dashboard/models/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';
class ElectricityConsumptionDashboardViewModel extends BaseViewModel {
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

  bool isShowErrorOnly = true; 
  bool isDashboardView = true;
  DateTime targetDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String targetGroupType = "工廠";
  final groupTypeMap = {
      "工廠" : DBConfig.locId,
      "樓層" : DBConfig.buildingId,
      "用電屬性 L2" : DBConfig.lineTypeId,
      "用電部門 L3" : DBConfig.departmentId,
      "設備類型 L4" : DBConfig.assetTypeId,
  };
  final eachLevelFilter ={
    DBConfig.locId : DBConfig.locId,
    DBConfig.buildingId : DBConfig.buildingId,
    DBConfig.lineTypeId : DBConfig.lineTypeId, 
    DBConfig.departmentId : DBConfig.departmentId,
    DBConfig.assetTypeId : DBConfig.assetTypeId,
  };

  final Map<String, dynamic>colorFilter ={
    DBConfig.locId : Colors.amber,
    DBConfig.buildingId : Colors.red,
    DBConfig.lineTypeId : Colors.blue, 
    DBConfig.departmentId : Colors.green,
    DBConfig.assetTypeId : Colors.grey,
  };

  int get currentLevel{
    int level = 0;
    for(level=0;level<eachLevelFilter.length;level++){
      if(eachLevelFilter[eachLevelFilter.keys.elementAt(level)] == eachLevelFilter.keys.elementAt(level)){
        break;
      }
    }
    return level +1 < eachLevelFilter.length ? level +1 : level;
  }

  List<String> orderFilterList({level = 1}){
    // debugPrint("level: $level");
    List<String> filterList = [];
    for(int i=0;i<level;i++){
      String key = eachLevelFilter.keys.elementAt(i);
      filterList.add(key);
      if(eachLevelFilter[key] != key && i != level-1){
        filterList.add(eachLevelFilter[key]!);
      }
    }
    // debugPrint(filterList.toString());
    return filterList;
  }
    
  // List<String> get groupType => groupTypeMap.keys.toList();

  ConsumptionSearchTree? consumptionDataSearchTree; 

  List<SumOfElectricityConsumptionDataModel> _sumOfConsumptionDataList = [];
  List<DeviceErrorReportModel> _deviceErrorReportList = [];
  List<ElectricityConsumptionDataModel> _electricityConsumptionDataList = [];

  void setEachLevelFilter(String key, String value){
    eachLevelFilter[key] = eachLevelFilter[key] == value ? key : value;
    int index = eachLevelFilter.keys.toList().indexOf(key);
    for(int i=index+1;i<eachLevelFilter.length;i++){
      eachLevelFilter[eachLevelFilter.keys.elementAt(i)] = eachLevelFilter.keys.elementAt(i);
    }
    notifyListeners();
  }

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
 
  List<DeviceErrorReportModel> get deviceErrorReportList => _deviceErrorReportList;

  List<ElectricityConsumptionDataModel> get electricityConsumptionDataList => _electricityConsumptionDataList;
  
  List<SumOfElectricityConsumptionDataModel> get sumOfElectricityConsumptionDataList => _sumOfConsumptionDataList;
  
  ConsumptionSearchTree? get getTodayConsumptionDataSearchTree => consumptionDataSearchTree?.searchByIndex([targetDateTime.toIso8601String()]);

  SumOfElectricityConsumptionDataModel get getOverAllData{
    ConsumptionSearchTree? tree = getTodayConsumptionDataSearchTree!.searchByIndex(
      orderFilterList(level: currentLevel)
    );
    tree!.print(depth: 0);
    return tree.root as SumOfElectricityConsumptionDataModel;
  }  

  List<SumOfElectricityConsumptionDataModel> getTimeGroupDataSource(ConsumptionSearchTree? tree, DateTime startTime, int days){
    List<SumOfElectricityConsumptionDataModel> timeGroupDataSource = [];
    for(int i=0;i<days;i++){
      List<String> filterList = orderFilterList(level: currentLevel)
        ..insert(0, startTime.subtract(Duration(days: i)).toIso8601String());
      timeGroupDataSource.add(
        DeviceGroupModel(
          dataSource: (tree!.searchByIndex(filterList)!.root! as DeviceGroupModel).dataSource,
          groupLabel: startTime.subtract(Duration(days: i)).toIso8601String()
        )
      );
    }
    return timeGroupDataSource.reversed.toList();
  }

  List<SumOfElectricityConsumptionDataModel> get weeklySumOfElectricityConsumptionDataList
    => getTimeGroupDataSource(consumptionDataSearchTree, targetDateTime, 7);
  
  List<SumOfElectricityConsumptionDataModel> get lastWeekSumOfElectricityConsumptionDataList
    => getTimeGroupDataSource(consumptionDataSearchTree, targetDateTime.subtract(const Duration(days: 7)), 7);

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
    _deviceErrorReportList = [];
    // setGroupType = groupType.first;
    setLoadingState(LoadingState.loading);
    try{
      // get device list and index 
      var deviceList = await deviceClient.search();
      var deviceIndexList = deviceList.map((e) => e.device?.tagId ?? "").toSet().toList();
      // _electricityConsumptionDataList = await consumptionClient.search(query: {"sort": [{" ": {"order": "desc"}}]});
      _electricityConsumptionDataList = await consumptionClient.search();
      _sumOfConsumptionDataList = [];

      for(String? tagId in deviceIndexList){
        var result = await getSumConsumptionDataByTime(
          targetDateTime.subtract(const Duration(days: 14)), 
          targetDateTime.add(const Duration(hours: 23, minutes: 59, seconds: 59)),
          tagId
        );
        if(result.isNotEmpty){
          _sumOfConsumptionDataList.addAll(result);
        }else{
          debugPrint("no device data for $tagId");
        }
      }
      consumptionDataSearchTree = ConsumptionSearchTree.buildTree(
        _sumOfConsumptionDataList, 
        [DBConfig.dateTimeId, ...groupTypeMap.values.toList()]
      );
      consumptionDataSearchTree!.print(depth: 0);

      _deviceErrorReportList = await errorReportClient.search();
      debugPrint("deviceErrorReport Number: ${_deviceErrorReportList.length}");
    }catch(e){
      debugPrint(e.toString());
      setLoadingState(LoadingState.error);
    }
    setLoadingState(LoadingState.free);
  }
}
