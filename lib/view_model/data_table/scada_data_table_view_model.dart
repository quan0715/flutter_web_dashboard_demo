import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';

class ScadaDataTableViewModel extends BaseViewModel{
  // view model data
  List<ElectricityConsumptionDataModel> dataList = [];

  DateTime _searchStartTime = DateTime.now();
  DateTime _searchEndTime = DateTime.now();
  DateTime get searchStartTime => DateTime(_searchStartTime.year, _searchStartTime.month, _searchStartTime.day, 0, 0 , 0);
  DateTime get searchEndTime => DateTime(_searchEndTime.year, _searchEndTime.month, _searchEndTime.day, 23, 59, 59);

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
  }

  set searchEndTime(DateTime newTime){
    _searchEndTime = newTime;
    checkSearchTimeOrder();
    init();
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
      "sort": [{"datetime": { "order": "desc"}}]
  };

  @override
  Future<void> init() async {
    setLoadingState(LoadingState.loading);
    dataList = await ElasticSearchClient.consumptionClient().search(query: queryObject);
    setLoadingState(LoadingState.error);
  }
  // view model getter and setter
  List<ElectricityConsumptionDataModel> get dataSource => dataList;
  set updateDeviceErrorReportData(List<ElectricityConsumptionDataModel> value){
    dataList = value;
    notifyListeners();
  }
}