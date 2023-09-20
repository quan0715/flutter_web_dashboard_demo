import 'package:flutter/material.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/data/filter_data_class.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search/consumption_search_node.dart';
import 'package:web_dashboard/models/search/filter_search_node.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';

class ElectricityConsumptionDashboardViewModel extends BaseViewModel {
  ConsumptionSearchNode? consumptionDataGroupSearchTree;
  FilterSearchTreeNode? filterSearchTreeNode;
  bool isShowConsumptionData = true;
  DateTime targetDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<LayerFilterData<String>> filterOrder = [
    LayerFilterData.init(layerLabel: "L1 廠區", layerIndex: DBConfig.locId),
    LayerFilterData.init(layerLabel: "L2 建築", layerIndex: DBConfig.buildingId),
    LayerFilterData.init(layerLabel: "L3 產線類別",layerIndex: DBConfig.lineTypeId),
    LayerFilterData.init(layerLabel: "L4 用電部門", layerIndex: DBConfig.departmentId),
    LayerFilterData.init(layerLabel: "L5 設備部門",layerIndex: DBConfig.assetTypeId),
  ];
      
  List<SumOfElectricityConsumptionDataModel> _sumOfConsumptionDataList = [];
  List<DeviceErrorReportModel> _deviceErrorReportList = [];
  // List<ElectricityConsumptionDataModel> _electricityConsumptionDataList = [];

  set setFilterOrder(List<LayerFilterData<String>> value){
    filterOrder = value;
    filterSearchTreeNode = FilterSearchTreeNode.buildTree(data: filterOrder);
    consumptionDataGroupSearchTree = ConsumptionSearchNode.buildTree(
      data: _sumOfConsumptionDataList,
      indexes: [DBConfig.dateTimeId, ...filterOrder.map((e) => e.layerIndex).toList()]
    );
    notifyListeners(); 
  }

  set setTargetDateTime(DateTime dateTime){
    targetDateTime = dateTime;
    init();
  }

  set setIsDashboard(bool value){
    isShowConsumptionData = value;
    notifyListeners();
  }
  
  List<String> get getSearchList => filterSearchTreeNode!.levelList();

  List<DeviceErrorReportModel> get deviceErrorReportList => _deviceErrorReportList;
  
  List<SumOfElectricityConsumptionDataModel> get sumOfElectricityConsumptionDataList => _sumOfConsumptionDataList;

  List<SumOfElectricityConsumptionDataModel> get sortedByBillSumOfElectricityConsumptionDataList => 
    _sumOfConsumptionDataList..sort((a, b) => b.dayBillPrice!.compareTo(a.dayBillPrice!));
  
  ConsumptionSearchNode? get getTodayData{
    var r = consumptionDataGroupSearchTree!.searchTree([targetDateTime.toIso8601String()]);
    if (r == null) {
      debugPrint('search tree $getSearchList is null');
      return null;
    }
    return r as ConsumptionSearchNode;
  }

  ConsumptionSearchNode? get getOverAllData{
    var r = getTodayData!.searchTree(getSearchList);
    if (r == null) {
      debugPrint('search tree $getSearchList is null');
      return null;
    }
    // r.printTree();
    return r as ConsumptionSearchNode;
  }


  
  List<SearchTreeNode> getTimeGroupDataSource(SearchTreeNode? tree, DateTime startTime, int days){
    List<SearchTreeNode> timeGroupDataSource = [];
    for(int i=0;i<days;i++){
      List<String> filterList = getSearchList
        ..insert(0, startTime.subtract(Duration(days: i)).toIso8601String());
      var r = tree!.searchTree(filterList);
      if(r == null){
        // debugPrint('search tree $filterList is null');
        return [];
      }
      else{
        timeGroupDataSource.add(r);
      }
     
    }
    return timeGroupDataSource.reversed.toList();
  }

  List<SearchTreeNode> get weeklySumOfElectricityConsumptionDataList
    => getTimeGroupDataSource(consumptionDataGroupSearchTree, targetDateTime, 7);
  
  List<SearchTreeNode> get lastWeekSumOfElectricityConsumptionDataList
    => getTimeGroupDataSource(consumptionDataGroupSearchTree, targetDateTime.subtract(const Duration(days: 7)), 7);

  Future<List<SumOfElectricityConsumptionDataModel>> getSumConsumptionDataByTime(DateTime startTime, DateTime endTime, String? tagId) async{
    Map<String, dynamic> query = {};
    int maxResult = 9999;
    Map<String, Map<String,String>> targetDateTime = {
      DBConfig.dateTimeId: {
        "time_zone": "+08:00",
        "gte": startTime.toIso8601String(),
        "lte": endTime.toIso8601String()
      }
    };
    List queryConditionList = [
      {"match": {DBConfig.tagIdId : tagId}},
      {"range": targetDateTime}
    ];
  List sortList = [{DBConfig.dateTimeId: {"order": "desc"}}];
    query
      ..['size'] = maxResult
      ..['query'] = {'bool': {"must" : queryConditionList}}
      ..['sort'] = sortList;
    return await ElasticSearchClient.sumOfConsumptionClient().search(query: query);
  }
  
  @override
  Future<void> init() async{
    _deviceErrorReportList = [];
    filterSearchTreeNode = FilterSearchTreeNode.buildTree(data: filterOrder);
    // debugPrint(filterSearchTreeNode!.toList().toString());
    setLoadingState(LoadingState.loading);
    try{
      var deviceIndexList = (await ElasticSearchClient.deviceClient().search()).map((e) => e.device?.tagId ?? "").toSet().toList();
      
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
      consumptionDataGroupSearchTree = ConsumptionSearchNode.buildTree(
        data: _sumOfConsumptionDataList,
        indexes: [DBConfig.dateTimeId, ...filterOrder.map((e) => e.layerIndex).toList()]
      );

      _deviceErrorReportList = await ElasticSearchClient.errorReportClient().search();
    }catch(e){
      debugPrint(e.toString());
      setLoadingState(LoadingState.error);
      rethrow;
    }
    setLoadingState(LoadingState.free);
  }
}
