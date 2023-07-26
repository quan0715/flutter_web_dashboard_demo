import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:web_dashboard/models/repo/monitoring_device.dart';

class MonitoringDeviceManageViewModel extends ChangeNotifier{
  bool _isLoading = false;
  List<MonitoringDeviceModel> _monitoringDeviceList = [];
  bool get isLoading => _isLoading;
  List<MonitoringDeviceModel> get monitoringDeviceList => _monitoringDeviceList;

  set updateMonitoringDeviceData(List<MonitoringDeviceModel> value) {
    _monitoringDeviceList = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> init() async{
    isLoading = true;
    notifyListeners();
    updateMonitoringDeviceData = await MonitoringDeviceModel.getFromRepo();
    isLoading = false;
    notifyListeners();
  }

  Future<void> upload() async {
    try {
      FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result != null) {
        PlatformFile csvFile = result.files.first;
        final content = utf8.decode(csvFile.bytes!); 
        debugPrint(content.toString());
        List<List<dynamic>> listData = const CsvToListConverter().convert(content, eol: "\n");
        List<String> key = listData[0].map((e) => e.toString()).toList();
        listData.removeAt(0);
        List<Map<String, dynamic>> r = listData.map((e) => Map.fromIterables(key, e)).toList();
        updateMonitoringDeviceData = r.map((json) => MonitoringDeviceModel.fromJson(json)).toList();
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  // Future<void> updateDataSource({String filePath = "/data/test.csv"}) async {
  //   final result = await rootBundle.loadString(filePath);
  //   List<List<dynamic>> listData = const CsvToListConverter().convert(result, eol: "\n");
  //   List<String> key = listData[0].map((e) => e.toString()).toList();
  //   listData.removeAt(0);
  //   List<Map<String, dynamic>> content = listData.map((e) => Map.fromIterables(key, e)).toList();
  //   updateMonitoringDeviceData = content.map((json) => MonitoringDeviceModel.fromJson(json)).toList();
  // }
}