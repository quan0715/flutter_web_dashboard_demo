import 'package:flutter/material.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search_node.dart';
import 'package:web_dashboard/models/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';
import 'package:web_dashboard/views/components/widget/tree_search_card.dart';
class ElectricityConsumptionDashboardViewModel extends BaseViewModel {
  ConsumptionSearchNode? consumptionDataGroupSearchTree;
  FilterSearchTreeNode? filterSearchTreeNode;

  bool isDashboardView = true;
  DateTime targetDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<LayerFilterData<String>> filterOrder = [
      LayerFilterData(
        layerLabel: "廠區",
        layerSelectedIndex: DBConfig.locId,
        layerIndex: DBConfig.locId,
      ),
      LayerFilterData(
        layerLabel: "建築",
        layerSelectedIndex: DBConfig.buildingId,
        layerIndex: DBConfig.buildingId,
      ),
      LayerFilterData(
        layerLabel: "產線類別",
        layerSelectedIndex: DBConfig.lineTypeId,
        layerIndex: DBConfig.lineTypeId,
      ),
      LayerFilterData(
        layerLabel: "用電部門",
        layerSelectedIndex: DBConfig.departmentId,
        layerIndex: DBConfig.departmentId,
      ),
      LayerFilterData(
        layerLabel: "設備部門",
        layerSelectedIndex: DBConfig.assetTypeId,
        layerIndex: DBConfig.assetTypeId,
      ),
    ];
      
  List<SumOfElectricityConsumptionDataModel> _sumOfConsumptionDataList = [];
  List<DeviceErrorReportModel> _deviceErrorReportList = [];
  List<ElectricityConsumptionDataModel> _electricityConsumptionDataList = [];

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
    isDashboardView = value;
    notifyListeners();
  }
  
  List<String> get getSearchList => filterSearchTreeNode!.levelList();

  List<DeviceErrorReportModel> get deviceErrorReportList => _deviceErrorReportList;

  List<ElectricityConsumptionDataModel> get electricityConsumptionDataList => _electricityConsumptionDataList;
  
  List<SumOfElectricityConsumptionDataModel> get sumOfElectricityConsumptionDataList => _sumOfConsumptionDataList;
  
  ConsumptionSearchNode? get getTodayConsumptionDataSearchTree 
    => consumptionDataGroupSearchTree!.searchTree([targetDateTime.toIso8601String()]) as ConsumptionSearchNode;

  ConsumptionSearchNode? get getOverAllData
    => getTodayConsumptionDataSearchTree!.searchTree(getSearchList) as ConsumptionSearchNode;
  
  List<SearchTreeNode> getTimeGroupDataSource(SearchTreeNode? tree, DateTime startTime, int days){
    List<SearchTreeNode> timeGroupDataSource = [];
    for(int i=0;i<days;i++){
      List<String> filterList = getSearchList
        ..insert(0, startTime.subtract(Duration(days: i)).toIso8601String());
      timeGroupDataSource.add(
        tree!.searchTree(filterList)!
      );
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
    List sortList = [{DBConfig.dateTimeId: {"order": "asc"}}];
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
      _electricityConsumptionDataList = await ElasticSearchClient.consumptionClient().search();
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
      // consumptionDataGroupSearchTree!.printTree(depth: 0);
      _deviceErrorReportList = await ElasticSearchClient.errorReportClient().search();
    }catch(e){
      debugPrint(e.toString());
      setLoadingState(LoadingState.error);
      rethrow;
    }
    setLoadingState(LoadingState.free);
  }
}
