import 'package:flutter/material.dart';
import 'package:web_dashboard/models/ammeter_model.dart';
import 'package:web_dashboard/models/electricity_amount_proportion.dart';
import 'package:web_dashboard/models/electricity_flow_data.dart';
import 'package:web_dashboard/models/error_report_model.dart';
import 'package:web_dashboard/models/fake_data.dart';

class ElectricityDataDashboardViewModel extends ChangeNotifier{

  AmmeterModel ammeterModel;
  AmmeterModel? currentSelectedAmmeterModel;
  List<AmmeterModel> _l1WorkspaceHeaderList = [];
  // List<AmmeterModel> _l2WorkspaceHeaderList = [];

  int _currentSelectedL1Index = 0;
  int _currentSelectedL2Index = 0;
  ElectricityDataDashboardViewModel({required this.ammeterModel}){
    _l1WorkspaceHeaderList = [
      ammeterModel,
      ...ammeterModel.subAmmeters
    ];
    currentSelectedAmmeterModel = ammeterModel;
    _currentSelectedL1Index = 0;
    _currentSelectedL2Index = 0;
    l1Selected = true;
  }

  int get currentSelectedL1Index => _currentSelectedL1Index;
  int get currentSelectedL2Index => _currentSelectedL2Index;

  List<AmmeterModel> get l1WorkspaceHeaderList => _l1WorkspaceHeaderList;
  List<AmmeterModel> get l2WorkspaceHeaderList => [
    l1WorkspaceHeaderList[currentSelectedL1Index],
    ...l1WorkspaceHeaderList[currentSelectedL1Index].subAmmeters
  ];
  AmmeterModel get rootAmmeter => ammeterModel;
  AmmeterModel get currentSelectedAmmeter => currentSelectedAmmeterModel!;
  ElectricityFlowData get currentSelectedAmmeterEData => currentSelectedAmmeter.ammeterData;
  String get queryName => "${currentSelectedAmmeter.name}-${currentSelectedAmmeter.label}";
  List<AmmeterModel> get subAmmeterData => currentSelectedAmmeter.subAmmeters;
  List<ElectricityAmountProportion> get weaklyAccumulatedElectricityFlow => currentSelectedAmmeter.getProportion;
  bool l1Selected = true;
  
  set currentL1SelectedIndex(int value){
    _currentSelectedL1Index = value;
    currentSelectedAmmeterModel = l1WorkspaceHeaderList[value];
    notifyListeners();
  }
  
  set currentL2SelectedIndex(int value){
    _currentSelectedL2Index = value;
    currentSelectedAmmeterModel = l2WorkspaceHeaderList[value];
    // currentSelectedAmmeterModel = value;
    notifyListeners();
  }


  List<AmmeterErrorReportModel> get ammeterErrorReportList => FakeData.generateFakeErrorReport(currentSelectedAmmeterModel!);

  void refreshPage(){
    debugPrint("update");
    ammeterModel = FakeData.generateFakeData();
    notifyListeners();
  }
}