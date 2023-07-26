import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_dashboard/models/repo/base_repo.dart';
class MonitoringDeviceModel implements BaseRepo{
  static String index = "metermsd";
  final String? loc;
  final String? building;
  final String? tagId;
  final String? groupId;
  final String? description;
  final String? changeBy;
  final DateTime? changeDate;
  

  MonitoringDeviceModel({
    required this.loc,
    required this.building,
    required this.tagId,
    required this.groupId,
    required this.description,
    required this.changeBy,
    required this.changeDate
  });

  @override
  String toString() {
    // TODO: implement toString
    return "loc: $loc, building: $building, tagId: $tagId, groupId: $groupId, description: $description, changeBy: $changeBy, changeDate: ${changeDate?.toIso8601String()}";
  }
  
  @override
  static MonitoringDeviceModel fromJson(Map<String, dynamic> json) {
    return MonitoringDeviceModel(
      loc: json['loc'],
      building: json['building'],
      tagId: json['tagid'],
      groupId: json['type'],
      description: json['desc'],
      changeBy: json['changeby'],
      changeDate: DateTime.parse(json['changetime'] as String),
    );
  }
  
  @override
  static Future<List<MonitoringDeviceModel>> getFromRepo() async {
    debugPrint("load Device data from repo");
    List<MonitoringDeviceModel> result = [];
    try{
      final response = await http.get(
      Uri.parse("${BaseRepo.baseURI}/$index/_search"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': BaseRepo.apiKey
        },
      );
      if(response.statusCode == 200){
        // debugPrint(response.body);
        Map<String, dynamic> json = jsonDecode(response.body);
        for(var item in json['hits']['hits']){
          debugPrint(item['_source'].toString());
          result.add(MonitoringDeviceModel.fromJson(item['_source']));
        }
        return result;
      }else{
        debugPrint(response.body);
        return [];
      }
    } catch(e){
      debugPrint(e.toString());
    }
    return [];
  }
  
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}