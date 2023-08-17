import 'package:flutter/material.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/group_consumption_data_model.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search_tree.dart';
import 'package:web_dashboard/models/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';
import 'package:web_dashboard/views/components/widget/tree_search_card.dart';
class ElectricityConsumptionDashboardViewModel extends BaseViewModel {
  // elastic search client for ElectricityConsumptionDataModel
  final consumptionClient = ElasticSearchClient.consumptionClient();
  // elastic search client for SumOfElectricityConsumptionDataModel
  final sumOfConsumptionClient = ElasticSearchClient.sumOfConsumptionClient();
  // elastic search client for DeviceErrorReportModel
  final errorReportClient = ElasticSearchClient.errorReportClient();
  // elastic search device data client
  final deviceClient = ElasticSearchClient.deviceClient();
  // bool isShowErrorOnly = true; 
  ConsumptionSearchTree? consumptionDataSearchTree; 
  bool isDashboardView = true;
  DateTime targetDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  
  List<String> get getSearchList =>
    treeSearchData.root.levelList() as List<String>;
  
  TreeSearchData treeSearchData = TreeSearchData<String>(
    root: TreeLayer(
      layerLabel: "L1 廠區",
      layerIndex: DBConfig.locId,
      childLayer: TreeLayer(
        layerLabel: "L2 建築",
        layerIndex: DBConfig.buildingId,
        childLayer: TreeLayer(
          layerLabel: "L3 產線類別",
          layerIndex: DBConfig.lineTypeId,
          childLayer: TreeLayer(
            layerLabel: "L4 用電部門",
            layerIndex: DBConfig.departmentId,
            childLayer: TreeLayer(
              layerLabel: "L5 設備部門",
              layerIndex: DBConfig.assetTypeId,
            )
          )
        )
      )
    )
  );  
      
  List<SumOfElectricityConsumptionDataModel> _sumOfConsumptionDataList = [];
  List<DeviceErrorReportModel> _deviceErrorReportList = [];
  List<ElectricityConsumptionDataModel> _electricityConsumptionDataList = [];

  set setTargetDateTime(DateTime dateTime){
    targetDateTime = dateTime;
    init();
    // notifyListeners();
  }

  set setIsDashboard(bool value){
    // if isDashboard is true then show the dashboard,
    // otherwise, show the table view
    isDashboardView = value;
    notifyListeners();
  }
  
  List<DeviceErrorReportModel> get deviceErrorReportList => _deviceErrorReportList;

  List<ElectricityConsumptionDataModel> get electricityConsumptionDataList => _electricityConsumptionDataList;
  
  List<SumOfElectricityConsumptionDataModel> get sumOfElectricityConsumptionDataList => _sumOfConsumptionDataList;
  
  ConsumptionSearchTree? get getTodayConsumptionDataSearchTree => consumptionDataSearchTree?.searchByIndex([targetDateTime.toIso8601String()]);

  SumOfElectricityConsumptionDataModel get getOverAllData{
    // debugPrint(getSearchList.toString());
    ConsumptionSearchTree? tree = getTodayConsumptionDataSearchTree!.searchByIndex(getSearchList);
    // debugPrint(tree.runtimeType.toString());
    // tree!.print(depth: 0);
    return tree!.root as SumOfElectricityConsumptionDataModel;
  }  

  List<SumOfElectricityConsumptionDataModel> getTimeGroupDataSource(ConsumptionSearchTree? tree, DateTime startTime, int days){
    List<SumOfElectricityConsumptionDataModel> timeGroupDataSource = [];
    for(int i=0;i<days;i++){
      List<String> filterList = getSearchList
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
              "match": {"tagid" : tagId}
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
    setLoadingState(LoadingState.loading);
    try{
      // get device list and index 
      var deviceIndexList = (await deviceClient.search()).map((e) => e.device?.tagId ?? "").toSet().toList();
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
      debugPrint(treeSearchData.getSearchIndexOrderList.toString());
      consumptionDataSearchTree = ConsumptionSearchTree.buildTree(
        _sumOfConsumptionDataList, 
        [DBConfig.dateTimeId, ...treeSearchData.getSearchIndexOrderList]
      );
      consumptionDataSearchTree!.print(depth: 0);
      _deviceErrorReportList = await errorReportClient.search();
      // debugPrint("deviceErrorReport Number: ${_deviceErrorReportList.length}");
    }catch(e){
      debugPrint(e.toString());
      setLoadingState(LoadingState.error);
    }
    // debugPrint(treeSearchData.root.levelList.toString());
    // getTodayConsumptionDataSearchTree!.searchByIndex(treeSearchData.root.levelList as List<String>)!.print(depth: 0);
    setLoadingState(LoadingState.free);
  }
}
