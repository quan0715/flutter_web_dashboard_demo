import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/error_report.dart';

class DeviceErrorReportViewModel extends ChangeNotifier{
  // view model data
  bool _isLoading = false;
  
  // view model getter and setter
  bool get isLoading => _isLoading;
  List<DeviceErrorReportModel> get dataSource => [
    // DeviceErrorReportModel(
    //   errorType: ElectricityConsumptionErrorType.sharplyIncrease,
    //   errorDescription: "異常描述",
    //   startTime: DateTime.now(),
    //   loc: "G1",
    //   building: "M10",
    //   tagId: "MACS_MACS0001_KWH",
    //   ampere: 30,
    //   volt: 110,
    //   power: 220,
    // ),
    // generate 10 fake data
    ...List.generate(20, (index) => DeviceErrorReportModel(
      errorType: ElectricityConsumptionErrorType.sharplyIncrease,
      errorDescription: "",
      startTime: DateTime.now(),
      loc: "G1",
      building: "M10",
      tagId: "MACS_MACS0001",
      ampere: 30,
      volt: 110,
      power: 220,
    ))
  ];

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