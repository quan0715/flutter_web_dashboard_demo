import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/consumption_repo_model.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';

class DailyScadaDataViewModel extends BaseViewModel{
  // view model data
  List<SumOfElectricityConsumptionDataModel> dataList = [];

  @override
  Future<void> init() async {
    setLoadingState(LoadingState.loading);
    dataList = await ElasticSearchClient.sumOfConsumptionClient().search(
        query: {
          "size": 9999,
          "query": {
            "bool": {
              "must": [
                {
                  "range": {
                    "datetime": {
                      "time_zone": "+08:00",
                      "gte": DateTime.now().subtract(const Duration(days: 14)).toIso8601String(),
                      "lte": DateTime.now().add(const Duration(hours: 23, minutes: 59, seconds: 59)).toIso8601String()
                    }
                  }
                },
              ]
            }
          },
          "sort": [
            {
              "datetime": {
                "order": "desc"
              }
            }
          ]
        }
      );
    setLoadingState(LoadingState.error);
  }
  // view model getter and setter
  List<SumOfElectricityConsumptionDataModel> get dataSource => dataList;
  set updateDeviceErrorReportData(List<SumOfElectricityConsumptionDataModel> value){
    dataList = value;
    notifyListeners();
  }
}