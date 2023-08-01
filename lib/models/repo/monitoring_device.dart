import 'dart:convert'; import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;
import 'package:web_dashboard/models/repo/base_repo.dart';
class MonitoringDeviceModel implements RepoModel{
  @override
  String index = "metermsd";
  
  final String? loc;
  final String? building;
  final String? tagId;
  final String? groupId;
  final String? description;
  final String? changeBy;
  final DateTime? changeDate;
  final String? repoId;

  MonitoringDeviceModel({
	  this.loc,
	  this.building,
	  this.tagId,
	  this.groupId,
	  this.description,
	  this.changeBy,
	  this.changeDate,
    this.repoId,
	});

  @override
  String toString() {
    // TODO: implement toString
    return "loc: $loc, building: $building, tagId: $tagId, groupId: $groupId, description: $description, changeBy: $changeBy, changeDate: ${changeDate?.toIso8601String()}, repoId: $repoId";
  }
  
  factory MonitoringDeviceModel.getInstance(){
    return MonitoringDeviceModel();
  }

  @override
  MonitoringDeviceModel fromJson(Map<String, dynamic> json) {
    return MonitoringDeviceModel(
      loc: json['_source']['loc'],
      building: json['_source']['building'],
      tagId: json['_source']['tagid'],
      groupId: json['_source']['type'],
      description: json['_source']['desc'],
      changeBy: json['_source']['changeby'],
      changeDate: DateTime.parse(json['_source']['changetime'] as String),
      repoId: json['_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
		// turn all null value to empty string
		return <String, dynamic>{
			"loc": loc ?? "",	
			"building": building ?? "",
			"tagid": tagId ?? "",
			"type": groupId ?? "",
			"desc": description ?? "",
			"changeby": changeBy ?? "",
			"changetime": changeDate?.toIso8601String() ?? "",
		};
	}
  
   @override
   set repoId(String? _repoId) {
    repoId = _repoId;
   }

}
