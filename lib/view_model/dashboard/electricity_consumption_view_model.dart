
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';

class ElectricityConsumptionDashboardViewModel extends ChangeNotifier{
  bool isLoading = false;
  String targetFactoryId = "G1";
  String targetBuildingId = "全";
  // if isShowAll is true, then show all the data
  // otherwise, show the device data which is not normal or with error report 
  bool isShowErrorOnly = true; 
  bool isDashboardView = true;

  List<ElectricityConsumptionDataModel> electricityConsumptionDataList = [];
  ElasticSearchClient<ElectricityConsumptionDataModel> client = ElasticSearchClient.fromModel(ElectricityConsumptionDataModel.getInstance());
  ElasticSearchClient<SumOfElectricityConsumptionDataModel> sumClient = ElasticSearchClient.fromModel(SumOfElectricityConsumptionDataModel.getInstance());

  List<String> factoryList = ["G1", "G2", "G3"];
  List<String> buildingList = ["全", "M1", "M2", "M3"];

  set setTargetFactoryId(String id){
    targetFactoryId = id;
    notifyListeners();
  }

  set setTargetBuildingId(String id){
    targetBuildingId = id;
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
    // electricityConsumptionDataList = await client.search();
    final result = await sumClient.search();
    factoryList = electricityConsumptionDataList.map<String>((data) => data.loc!).toSet().toList();
    buildingList = electricityConsumptionDataList.map<String>((data) => data.building!).toSet().toList();
    buildingList.insert(0, "全");
    // debugPrint(result.length. toString());
    isLoading = false;
    notifyListeners();
  }
}
