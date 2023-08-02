import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';

class MonitoringDeviceManageViewModel extends ChangeNotifier {
  bool _isLoading = false;
  List<MonitoringDeviceModel> _monitoringDeviceList = [];
  String _missionDescription = "";
  int _missionCount = 0;
  int _missionCompleteCount = 0; 
  bool get isLoading => _isLoading;
  List<MonitoringDeviceModel> get monitoringDeviceList => _monitoringDeviceList;
  int get missionCount => _missionCount;
  int get missionCompleteCount => _missionCompleteCount;
  String get missionDescription => _missionDescription;
  double get missionProgressValue => missionCount == 0 ? 0 : missionCompleteCount / missionCount;
  

  ElasticSearchClient<MonitoringDeviceModel> client = ElasticSearchClient(
    index: MonitoringDeviceModel.getInstance().index,
    fromJson: MonitoringDeviceModel.getInstance().fromJson,
    toJson: MonitoringDeviceModel.getInstance().toJson,
  );

  set updateMonitoringDeviceData(List<MonitoringDeviceModel> value) {
    _monitoringDeviceList = value;
    debugPrint(_monitoringDeviceList.length.toString());
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    updateMonitoringDeviceData = await client.search();
    isLoading = false;
    notifyListeners();
  }

  // upload csv file using file picker
  // call when you need to update your advice monitoring device data (by manually upload csv file)
  // The function is only for transform file data to data class instead of upload the data to the server
  Future<void> uploadCsvFile() async {
    try {
      // limit picked file to csv file only
      FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
        type: FileType.custom, 
        allowedExtensions: ['csv'],
      );
      // if file is picked and is not null file
      // then convert the file to list of map and update the monitoring device data
      if (result != null) {
        // get the first file
        PlatformFile csvFile = result.files.first; 
        // get the first file
        final content = utf8.decode(csvFile.bytes!); 
        // convert the file content to list of list
        List<List<dynamic>> listData = const CsvToListConverter().convert(content, eol: "\n"); 
        // get the first list of the list (column name)
        List<String> key = listData[0].map((e) => e.toString()).toList();
        listData.removeAt(0);
        // convert the list of list to list of map
        List<Map<String, dynamic>> r = listData.map((e)
          => {'_source' : Map.fromIterables(key, e)}).toList();
        updateMonitoringDeviceData = r.map<MonitoringDeviceModel>((json) => client.fromJson(json)).toList();
        //monitoring_device_manage_view_model.dart.forEach((element) {debugPrint(element.toString());});
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  // update current monitoring device data to the server
  Future<void> uploadDataToRepo() async{
    // debugPrint(_monitoringDeviceList.toString());
    // MonitoringDeviceModel target =  monitoringDeviceList.first;
    // await MonitoringDeviceModel.postToRepo(target);
    isLoading = true;
    _missionCount = 0;
    _missionCompleteCount = 0;
    _missionDescription = "";
    notifyListeners();
    // await client.updateWholeDocumentToRepo(monitoringDeviceList);
    await for (Map<String, dynamic> event in client.test(_monitoringDeviceList)){
      _missionCount = event['missionCount'] as int;
      _missionCompleteCount = event['missionCompleteCount'] as int;
      _missionDescription = "${event['missionDescription'] as String} ($_missionCompleteCount/$_missionCount)";
      notifyListeners();
    }
    // debugPrint("test");
    _missionDescription = "重整中";
    updateMonitoringDeviceData = await client.search();
    isLoading = false; 
    notifyListeners();
  }
}
