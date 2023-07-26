
// Error report model for electricity consumption dashboard
// Path: lib/models/repo/error_report.dart
// 每分鐘更新資料
import 'package:flutter/material.dart';

class ErrorReportModel{
  final ElectricityConsumptionErrorType? errorType;
  final String? errorDescription;
  final DateTime? startTime;
  final String? loc;
  final String? building;
  final String? tagId;
  final int? ampere;
  final int? volt;
  final int? power;
  // constructor
  ErrorReportModel({
    this.errorType,
    this.errorDescription,
    this.startTime,
    this.loc,
    this.building,
    this.tagId,
    this.ampere,
    this.volt,
    this.power
  });
  // from json
  factory ErrorReportModel.fromJson(Map<String, dynamic> json){
    return ErrorReportModel(
      errorType: json['errorType'],
      errorDescription: json['errorDescription'],
      startTime: json['startTime'],
      loc: json['loc'],
      building: json['building'],
      tagId: json['tagId'],
      ampere: json['ampere'],
      volt: json['volt'],
      power: json['power']
    );
  }

  // to Json
  Map<String, dynamic> toJson() => {
    'errorType': errorType,
    'errorDescription': errorDescription,
    'startTime': startTime,
    'loc': loc,
    'building': building,
    'tagId': tagId,
    'ampere': ampere,
    'volt': volt,
    'power': power
  };

}

enum ElectricityConsumptionErrorType{
  sharplyIncrease(
    label: "徒增",
    iconsColor: Colors.red,
    icon: Icons.arrow_upward
  ),
  sharplyDecrease(
    label: "突降",
    iconsColor: Colors.orange,
    icon: Icons.arrow_downward
  ),
  abnormal(
    label: "異常",
    iconsColor: Colors.purple,
    icon: Icons.error
  ),
  other(
    label: "其他",
    iconsColor: Colors.amber,
    icon: Icons.error
  );
  const ElectricityConsumptionErrorType({
    required this.label,
    this.iconsColor = Colors.red,
    this.icon = Icons.error
  });
  final String label;
  final Color iconsColor;
  final IconData icon;
}