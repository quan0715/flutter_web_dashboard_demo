import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:web_dashboard/models/repo/elastic_search.dart';
import 'package:web_dashboard/models/repo/monitoring_device.dart';

class MonitoringDeviceManageViewModel extends ChangeNotifier {
  bool _isLoading = false;
  List<MonitoringDeviceModel> _monitoringDeviceList = [];
  bool get isLoading => _isLoading;
  List<MonitoringDeviceModel> get monitoringDeviceList => _monitoringDeviceList;
  ElasticSearchClient<MonitoringDeviceModel> client = ElasticSearchClient<MonitoringDeviceModel>(
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
        _monitoringDeviceList.forEach((element) {debugPrint(element.toString());});
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  // update current monitoring device data to the server
  Future<void> uploadDataToRepo() async{
    // TODO : just for test
    // debugPrint(_monitoringDeviceList.toString());
    // MonitoringDeviceModel target =  monitoringDeviceList.first;
    // await MonitoringDeviceModel.postToRepo(target);
    isLoading = true;
    notifyListeners();
    client.test(monitoringDeviceList).listen((event) {
      debugPrint(event.toString());
    });
    // await client.updateWholeDocumentToRepo(monitoringDeviceList);
    isLoading = false; 
    notifyListeners();
  }
}
