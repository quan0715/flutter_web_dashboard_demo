import 'package:flutter/material.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/data/filter_data_class.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search/consumption_search_node.dart';
import 'package:web_dashboard/models/search/filter_search_node.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';

class DailyScadaDataViewModel extends BaseViewModel{
  // view model data
  List<SumOfElectricityConsumptionDataModel> _dataList = [];
  List<SumOfElectricityConsumptionDataModel> get dataList{
    if(filterSearchTreeNode != null && consumptionDataGroupSearchTree != null){
      var searchList = filterSearchTreeNode!.levelList();
      // consumptionDataGroupSearchTree!.searchTree(searchList, matchAll: true)!.printTree();
      List<SumOfElectricityConsumptionDataModel> result = [];
      if(searchList.length == 1) {
        return _dataList;
      }
      // get time label
      var timeNode = consumptionDataGroupSearchTree!.searchTree(['all', 'datetime']);
      for (var node in timeNode!.children) {
        // debugPrint("node: ${node.index}");
        result.addAll(node.searchTree(searchList)!.toList() as List<SumOfElectricityConsumptionDataModel>);
      }
      return result;  
    }
    return _dataList;
  }
  DateTime _searchStartTime = DateTime.now();
  DateTime _searchEndTime = DateTime.now();
  DateTime get searchStartTime => DateTime(_searchStartTime.year, _searchStartTime.month, _searchStartTime.day - 7, 0, 0 , 0);
  DateTime get searchEndTime => DateTime(_searchEndTime.year, _searchEndTime.month, _searchEndTime.day, 23, 59, 59);

  ConsumptionSearchNode? consumptionDataGroupSearchTree;
  FilterSearchTreeNode? filterSearchTreeNode;
  List<LayerFilterData<String>> filterOrder = [
    LayerFilterData.init(layerLabel: "L1 廠區", layerIndex: DBConfig.locId),
    LayerFilterData.init(layerLabel: "L2 建築", layerIndex: DBConfig.buildingId),
    LayerFilterData.init(layerLabel: "L3 產線類別",layerIndex: DBConfig.lineTypeId),
    LayerFilterData.init(layerLabel: "L4 用電部門", layerIndex: DBConfig.departmentId),
    LayerFilterData.init(layerLabel: "L5 設備部門",layerIndex: DBConfig.assetTypeId),
    LayerFilterData.init(layerLabel: "L6 設備編號",layerIndex: DBConfig.tagIdId),
  ];

  void checkSearchTimeOrder(){
    if(_searchStartTime.isAfter(_searchEndTime)){
      DateTime temp = _searchStartTime;
      _searchStartTime = _searchEndTime;
      _searchEndTime = temp;
    }
  }

  set searchStartTime(DateTime newTime){
    _searchStartTime = newTime;
    checkSearchTimeOrder();
    init();
    notifyListeners();
  }

  set searchEndTime(DateTime newTime){
    _searchEndTime = newTime;
    checkSearchTimeOrder();
    init();
    notifyListeners();
  }

  Map<String, dynamic> get queryObject => {
      "size": 9999,
      "query": {
        "bool": {
          "must": [
            {
              "range": {
                "datetime": {
                  "time_zone": "+08:00",
                  "gte": searchStartTime.toIso8601String(),
                  "lte": searchEndTime.toIso8601String(),
                }
              }
            },
          ]
        }
      },
      "sort": [
        {
          "datetime": { "order": "desc"}
        }
      ]
  };



  @override
  Future<void> init() async {
    setLoadingState(LoadingState.loading);
    _dataList = await ElasticSearchClient.sumOfConsumptionClient().search(
        query: queryObject
    );
    consumptionDataGroupSearchTree = ConsumptionSearchNode.buildTree(
      data: dataList,
      indexes: [DBConfig.dateTimeId, ...filterOrder.map((e) => e.layerIndex).toList()]
    );
    // consumptionDataGroupSearchTree!.printTree();
    filterSearchTreeNode = FilterSearchTreeNode.buildTree(data: filterOrder);
    setLoadingState(LoadingState.error);
  }
  // view model getter and setter
  List<SumOfElectricityConsumptionDataModel> get dataSource => dataList;
  set updateDeviceErrorReportData(List<SumOfElectricityConsumptionDataModel> value){
    _dataList = value;
    notifyListeners();
  }
}