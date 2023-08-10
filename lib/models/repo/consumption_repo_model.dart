
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/bound.dart';
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';

class ElectricityConsumptionDataModel implements RepoModel{
  // Device electricity consumption data model 
  @override
  String index = DBConfig.deviceConsumptionRepoIndex;

  @override
  String? repoId; // db: _id

  final DateTime? recordTime; // db: datetime
  final MonitoringDeviceModel? deviceData;
  final BoundDataClass? boundData;

  final int? power; // db: kw
  final int? energyConsumed; // db: kwh
  final int? sumOfEnergyConsumed; // db: sum_kwh
  final int? ampere; // db: ampere
  final int? volt; // db: voltage
  // constructor
  ElectricityConsumptionDataModel({
    this.deviceData,
    this.boundData,
    this.recordTime,
    this.ampere,
    this.volt,
    this.power,
    this.energyConsumed,
    this.sumOfEnergyConsumed,
    this.repoId,
  });

  factory ElectricityConsumptionDataModel.getInstance() => ElectricityConsumptionDataModel();

  @override
  String toString() {
    return toJson().entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  @override
  ElectricityConsumptionDataModel fromJson(Map<String, dynamic> json) {
    // debugPrint(json.toString());
    try{
      debugPrint(json.toString());
      final source = json['_source'];
      return ElectricityConsumptionDataModel(
        recordTime: DateTime.parse(source['datetime'] as String),
        power: source['kw'],
        energyConsumed: source['kwh'],
        sumOfEnergyConsumed: source['sum_kwh'],
        ampere: source['ampere'],
        volt: source['voltage'],
        deviceData: MonitoringDeviceModel(
          tagId: source['tagid'] as String,
          loc: source['loc'] as String,
          building: source['building'] as String,
          assetType: source['assettype'] as String,
          lineType: source['linetype'] as String,
          department: source['department'] as String,
        ),
        boundData: BoundDataClass(
          lowerBound: source['lb'] as int,
          upperBound: source['ub'] as int,
          warningLowerBound: source['wlb'] as int,
          warningUpperBound: source['wub'] as int,
        ),
        repoId: json['_id'] as String,
      );
    } catch(e){
      debugPrint(json.toString());
      debugPrint(e.toString());
      rethrow ;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'datetime': recordTime?.toIso8601String(),
      'kw': power,
      'kwh': energyConsumed,
      'sum_kwh': sumOfEnergyConsumed,
      'ampere': ampere,
      'voltage': volt,
      'tagid': deviceData?.tagId,
      'loc': deviceData?.loc,
      'building': deviceData?.building,
      'assettype': deviceData?.assetType,
      'linetype': deviceData?.lineType,
      'department': deviceData?.department,
    };
  }

}