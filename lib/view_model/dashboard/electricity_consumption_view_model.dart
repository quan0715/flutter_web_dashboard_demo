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
  // SearchTree? consumptionDataSearchTree; 
  bool isDashboardView = true;
  DateTime targetDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
  }

  set setIsDashboard(bool value){
    isDashboardView = value;
    notifyListeners();
  }
  
  List<String> get getSearchList => 
    treeSearchData.root.levelList() as List<String>;

  List<DeviceErrorReportModel> get deviceErrorReportList => _deviceErrorReportList;

  List<ElectricityConsumptionDataModel> get electricityConsumptionDataList => _electricityConsumptionDataList;
  
  List<SumOfElectricityConsumptionDataModel> get sumOfElectricityConsumptionDataList => _sumOfConsumptionDataList;
  
  ConsumptionSearchNode? get getTodayConsumptionDataSearchTree => 
    consumptionDataGroupSearchTree!.searchTree([targetDateTime.toIso8601String()]) as ConsumptionSearchNode;

  ConsumptionSearchNode? get getOverAllData
    => getTodayConsumptionDataSearchTree!.searchTree(getSearchList) as ConsumptionSearchNode;
  

  List<SearchTreeNode> getTimeGroupDataSource(SearchTreeNode? tree, DateTime startTime, int days){
    List<SearchTreeNode> timeGroupDataSource = [];
    tree!.printTree(depth: 0);
    debugPrint(startTime.toIso8601String());
    debugPrint("days: $days");
    for(int i=0;i<days;i++){
      List<String> filterList = getSearchList
        ..insert(0, startTime.subtract(Duration(days: i)).toIso8601String());
      debugPrint(filterList.toString());
      timeGroupDataSource.add(
        tree!.searchTree(filterList)!..printTree(depth: 0)
      );
    }
    return timeGroupDataSource.reversed.toList();
  }

  List<SearchTreeNode> get weeklySumOfElectricityConsumptionDataList
    => getTimeGroupDataSource(consumptionDataGroupSearchTree, targetDateTime, 7);
  
  List<SearchTreeNode> get lastWeekSumOfElectricityConsumptionDataList
    => getTimeGroupDataSource(consumptionDataGroupSearchTree, targetDateTime.subtract(const Duration(days: 7)), 7);

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
    return await ElasticSearchClient.sumOfConsumptionClient().search(query: query);
  }
  
  @override
  Future<void> init() async{
    _deviceErrorReportList = [];
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
      debugPrint(treeSearchData.getSearchIndexOrderList.toString());
      consumptionDataGroupSearchTree = ConsumptionSearchNode.buildTree(
        data: _sumOfConsumptionDataList,
        indexes: [DBConfig.dateTimeId, ...treeSearchData.getSearchIndexOrderList]
      );
      // consumptionDataGroupSearchTree!.printTree(depth: 0);
      _deviceErrorReportList = await ElasticSearchClient.errorReportClient().search();
    }catch(e){
      debugPrint(e.toString());
      setLoadingState(LoadingState.error);
    }
    var test = [
      LayerFilterData(
        layerLabel: "L1 廠區",
        layerSelectedIndex: DBConfig.locId,
        layerIndex: DBConfig.locId,
      ),
      LayerFilterData(
        layerLabel: "L2 建築",
        layerSelectedIndex: DBConfig.buildingId,
        layerIndex: DBConfig.buildingId,
      ),
      LayerFilterData(
        layerLabel: "L3 產線類別",
        layerSelectedIndex: DBConfig.lineTypeId,
        layerIndex: DBConfig.lineTypeId,
      ),
      LayerFilterData(
        layerLabel: "L4 用電部門",
        layerSelectedIndex: DBConfig.departmentId,
        layerIndex: DBConfig.departmentId,
      ),
      LayerFilterData(
        layerLabel: "L5 設備部門",
        layerSelectedIndex: DBConfig.assetTypeId,
        layerIndex: DBConfig.assetTypeId,
      ),
    ];
    SearchTreeLayer s = SearchTreeLayer.buildTree(data: test);
    // SearchTreeLayer q = SearchTreeLayer.buildTree(data: test);
    s.printTree();
    // q.children.add(s.children.first); 
    // q.printTree();
    // debugPrint(s.levelList().toString());
    // debugPrint(getTodayConsumptionDataSearchTree!.toList().toString());
    // debugPrint(s.toList().toString());
    // for (var s in s.toList()){
    //   debugPrint(s.layerIndex);
    // }
    // s.searchTree(['loc', 'building', 'assettype'])!.printTree();
    setLoadingState(LoadingState.free);
  }
}
