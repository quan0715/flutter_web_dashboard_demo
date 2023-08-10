import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/models/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';

class DeviceErrorReportViewModel extends BaseViewModel{
  // view model data
  List<DeviceErrorReportModel> _deviceErrorReportList = [];
  ElasticSearchClient<DeviceErrorReportModel> client = ElasticSearchClient.fromModel(DeviceErrorReportModel.getInstance());
  
  @override
  Future<void> init() async {
    setLoadingState(LoadingState.loading);
    _deviceErrorReportList = await client.search();
    setLoadingState(LoadingState.error);
  }
  // view model getter and setter
  List<DeviceErrorReportModel> get dataSource => _deviceErrorReportList;
  set updateDeviceErrorReportData(List<DeviceErrorReportModel> value){
    _deviceErrorReportList = value;
    notifyListeners();
  }
}