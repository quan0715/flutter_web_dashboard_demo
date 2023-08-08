
// Error report model for electricity consumption dashboard
// Path: lib/models/repo/error_report.dart
// 每分鐘更新資料
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';

class DeviceErrorReportModel implements RepoModel {

  @override
  String index = DBConfig.errorReportRepoIndex;

  @override
  String? repoId;

  final ElectricityConsumptionErrorType? errorType;
  final String? errorDescription;
  final DateTime? startTime;
  final String? loc;
  final String? building;
  final String? tagId;
  final int? ampere;
  final int? volt;
  final int? power;
  final int? lb;
  final int? ub;
  // constructor
  DeviceErrorReportModel({
    this.errorType,
    this.errorDescription,
    this.startTime,
    this.loc,
    this.building,
    this.tagId,
    this.ampere,
    this.volt,
    this.power,
    this.lb,
    this.ub,
    this.repoId,
  });
  // from json
  factory DeviceErrorReportModel.getInstance(){
    return DeviceErrorReportModel();
  }
  @override
  DeviceErrorReportModel fromJson(Map<String, dynamic> json){
    debugPrint(json.toString());
    return DeviceErrorReportModel(
      errorType: ElectricityConsumptionErrorType.fromDBField(json['_source']['e_typ'] as String),
      // errorDescription: json['_source']['errorDescription'] as String,
      startTime: DateTime.parse(json['_source']['datetime'] as String),
      loc: json['_source']['loc'] as String ,
      building: json['_source']['building'] as String,
      tagId: json['_source']['tagid'] as String,
      ampere: json['_source']['ampere'],
      volt: json['_source']['voltage'],
      power: json['_source']['kw'],
      lb: json['_source']['lb'],
      ub: json['_source']['ub'],
      repoId: json['_id'] as String,
    );
  }

  // to Json
  @override
  Map<String, dynamic> toJson() => {
    'e_typ': errorType,
    // 'errorDescription': errorDescription,
    'datetime': startTime,
    'loc': loc,
    'building': building,
    'tagid': tagId,
    'A': ampere,
    'V': volt,
    'KW': power
  };

  @override
  String toString() {
    return "errorType: $errorType, errorDescription: $errorDescription, startTime: $startTime, loc: $loc, building: $building, tagId: $tagId, ampere: $ampere, volt: $volt, power: $power, repoId: $repoId";
  }
}

enum ElectricityConsumptionErrorType{
  sharplyIncrease(
    dbFieldName: "inc",
    label: "突增",
    iconsColor: Colors.red,
    icon: Icons.arrow_upward
  ),
  sharplyDecrease(
    dbFieldName: "dec",
    label: "突降",
    iconsColor: Colors.orange,
    icon: Icons.arrow_downward
  ),
  abnormal(
    dbFieldName: "error",
    label: "異常",
    iconsColor: Colors.purple,
    icon: Icons.error
  ),
  other(
    dbFieldName: "other",
    label: "其他",
    iconsColor: Colors.amber,
    icon: Icons.error
  );
  const ElectricityConsumptionErrorType({
    required this.label,
    this.dbFieldName = "",
    this.iconsColor = Colors.red,
    this.icon = Icons.error
  });
  final String label;
  final Color iconsColor;
  final IconData icon;
  final String dbFieldName;
  static ElectricityConsumptionErrorType fromLabel(String label){
    return ElectricityConsumptionErrorType.values.firstWhere((element) => element.label == label);
  }
  static ElectricityConsumptionErrorType fromDBField(String label){
    return ElectricityConsumptionErrorType.values.firstWhere((element) => element.dbFieldName == label);
  }
}