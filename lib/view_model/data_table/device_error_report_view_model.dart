import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';

class DeviceErrorReportViewModel extends BaseViewModel{
  // view model data
  List<DeviceErrorReportModel> _deviceErrorReportList = [];

  @override
  Future<void> init() async {
    setLoadingState(LoadingState.loading);
    _deviceErrorReportList = await ElasticSearchClient.errorReportClient().search();
    setLoadingState(LoadingState.error);
  }
  // view model getter and setter
  List<DeviceErrorReportModel> get dataSource => _deviceErrorReportList;
  set updateDeviceErrorReportData(List<DeviceErrorReportModel> value){
    _deviceErrorReportList = value;
    notifyListeners();
  }
}