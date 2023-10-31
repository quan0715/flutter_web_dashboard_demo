import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/data/filter_data_class.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search/consumption_search_node.dart';
import 'package:web_dashboard/models/search/filter_search_node.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';

class ConsumptionReportDashboardViewModel extends BaseViewModel {
  List<SumOfElectricityConsumptionDataModel> dataSource = [];
  List<SumOfElectricityConsumptionDataModel> lastYearDataSource = [];
  ConsumptionSearchNode? searchTree;
  SearchTreeNode? get consumptionDataGroupSearchTree => 
    searchTree!.searchTree(['YEAR', '2023 年','QUARTER', 'Q3', 'MONTH', '7 月', 'DAY']);
  SearchTreeNode? get lastYearConsumptionDataGroupSearchTree => 
    searchTree!.searchTree(['YEAR', '2022 年','QUARTER' , 'Q3', 'MONTH','7 月', 'DAY']);
  SearchTreeNode? filterSearchTreeNode;
  List<LayerFilterData<String>> filterOrder = [
      LayerFilterData(
        layerLabel: "YEAR",
        layerSelectedIndex: "YEAR",
        layerIndex: "YEAR",
      ),
      LayerFilterData(
        layerLabel: "QUARTER",
        layerSelectedIndex: "QUARTER",
        layerIndex: "QUARTER",
      ),
      LayerFilterData(
        layerLabel: "MONTH",
        layerSelectedIndex: "MONTH",
        layerIndex: "MONTH",
      ),
      LayerFilterData(
        layerLabel: "DAY",
        layerSelectedIndex: "DAY",
        layerIndex: "DAY",
      ),
    ];
  
  get monthReport => consumptionDataGroupSearchTree!.children;

  get lastYearMonthReport => lastYearConsumptionDataGroupSearchTree!.children;

  @override
  Future init() async {
    filterSearchTreeNode = FilterSearchTreeNode.buildTree(data: filterOrder);
    setLoadingState(LoadingState.loading);
    final deviceList = await ElasticSearchClient.deviceClient().search();
    final deviceListIndex = deviceList.map<String>((e) => e.device?.tagId ?? "").toList();
    for(String tagId in deviceListIndex){
      if(tagId.isNotEmpty){
        dataSource.addAll(
          await ElasticSearchClient.getSumConsumptionDataByTime(
            startTime: DateTime(2021, 1, 1), endTime: DateTime(2023, 12, 31), tagId: tagId
          )
        );
      }
    }
    searchTree = ConsumptionSearchNode.buildTree(data: dataSource); 
    searchTree!.addNewGroup(
      index: 'YEAR',
      indexBuilder: (node) => "${DateTime.parse(node.data!.getDataByKey(DBConfig.dateTimeId)).year} 年",
    );
    searchTree!.addNewGroup(
      index: 'QUARTER',
      indexBuilder: (node) => "Q${(DateTime.parse(node.data!.getDataByKey(DBConfig.dateTimeId)).month + 2) ~/ 3}",
    );
    // searchTree!.printTree(depth: 0);
    searchTree!.addNewGroup(
      index: 'MONTH',
      indexBuilder: (node) => "${DateTime.parse(node.data!.getDataByKey(DBConfig.dateTimeId)).month} 月",
    );
    searchTree!.addNewGroup(
      index: 'DAY',
      indexBuilder: (node) => "${DateTime.parse(node.data!.getDataByKey(DBConfig.dateTimeId)).day} 日",
    );
    setLoadingState(LoadingState.free);
  }

}