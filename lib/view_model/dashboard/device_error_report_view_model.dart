import 'package:flutter/material.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/error_report_repo_model.dart';

class DeviceErrorReportViewModel extends ChangeNotifier{
  // view model data
  bool _isLoading = false;
  List<DeviceErrorReportModel> _deviceErrorReportList = [];
  ElasticSearchClient<DeviceErrorReportModel> client = ElasticSearchClient(
    index: DeviceErrorReportModel.getInstance().index,
    fromJson: DeviceErrorReportModel.getInstance().fromJson,
    toJson: DeviceErrorReportModel.getInstance().toJson,
  );
  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    _deviceErrorReportList = await client.search();
    isLoading = false;
    notifyListeners();
  }
  // view model getter and setter
  bool get isLoading => _isLoading;
  List<DeviceErrorReportModel> get dataSource => _deviceErrorReportList;
  set updateDeviceErrorReportData(List<DeviceErrorReportModel> value){
    _deviceErrorReportList = value;
    notifyListeners();
  }
  // List<DeviceErrorReportModel> get dataSource => [
  //   ...List.generate(20, (index) => DeviceErrorReportModel(
  //     errorType: ElectricityConsumptionErrorType.sharplyIncrease,
  //     errorDescription: "",
  //     startTime: DateTime.now(),
  //     loc: "G1",
  //     building: "M10",
  //     tagId: "MACS_MACS0001",
  //     ampere: 30,
  //     volt: 110,
  //     power: 220,
  //   ))
  // ];

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  // view model method
  getFromRepo(){

  }

  updateToRepo(){

  }

}