
// Error report model for electricity consumption dashboard
// Path: lib/models/repo/error_report.dart
// 每分鐘更新資料
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/bound_data_class.dart';
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
  final int? voltage;
  final int? power;
  final BoundDataClass? boundData;
  // constructor
  DeviceErrorReportModel({
    this.errorType,
    this.errorDescription,
    this.startTime,
    this.loc,
    this.building,
    this.tagId,
    this.ampere,
    this.voltage,
    this.power,
    this.boundData,
    this.repoId,
  });
  // from json
  factory DeviceErrorReportModel.getInstance(){
    return DeviceErrorReportModel();
  }
  @override
  DeviceErrorReportModel fromJson(Map<String, dynamic> json){
    var s = json['_source'] as Map<String, dynamic>;
    return DeviceErrorReportModel(
      errorType: ElectricityConsumptionErrorType.fromDBField(s[DBConfig.errorTypeId]),
      errorDescription: "",
      startTime: DateTime.parse(s[DBConfig.dateTimeId] as String),
      loc: s[DBConfig.locId] as String,
      building: s[DBConfig.buildingId] as String,
      tagId: s[DBConfig.tagIdId] as String,
      ampere: s[DBConfig.ampereId] as int,
      voltage: s[DBConfig.voltageId] as int,
      power: s[DBConfig.powerId] as int,
      boundData: BoundDataClass.fromJson(s),
      repoId: json['_id'] as String,
    );
  }

  // to Json
  @override
  Map<String, dynamic> toJson() => {
    DBConfig.errorTypeId : errorType.toString(),
    DBConfig.dateTimeId : startTime.toString(),
    DBConfig.locId : loc,
    DBConfig.buildingId : building,
    DBConfig.tagIdId : tagId,
    DBConfig.ampereId : ampere,
    DBConfig.voltageId : voltage,
    DBConfig.powerId : power,
  }..addEntries(boundData!.toJson().entries ?? []);

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