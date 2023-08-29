
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/data/bound_data_class.dart';
import 'package:web_dashboard/models/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/data/device_data_class.dart';

class ElectricityConsumptionDataModel implements RepoModel{
  // Device electricity consumption data model 
  @override
  String index = DBConfig.deviceConsumptionRepoIndex;

  @override
  String? repoId; // db: _id

  final DateTime? recordTime; // db: datetime
  final DeviceDataClass? deviceData;
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
  ElectricityConsumptionDataModel fromJson(Map<String, dynamic> json) {
    try{
      final source = json['_source'];
      return ElectricityConsumptionDataModel(
        recordTime: DateTime.parse(source[DBConfig.dateTimeId] as String),
        power: source[DBConfig.powerId],
        energyConsumed: source[DBConfig.powerConsumptionId],
        sumOfEnergyConsumed: source[DBConfig.sumOfEnergyConsumedId],
        ampere: source[DBConfig.ampereId],
        volt: source[DBConfig.voltageId],
        deviceData: DeviceDataClass.fromJson(source),
        boundData: BoundDataClass.fromJson(source),
        repoId: json['_id'] as String,
      );
    } catch(e){
      debugPrint(DBConfig.jsonSerializerMessage(index, '$e\n$json'));
      rethrow ;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      DBConfig.dateTimeId : recordTime?.toIso8601String(),
      DBConfig.powerId : power ?? 0,
      DBConfig.powerConsumptionId : energyConsumed ?? 0,
      DBConfig.sumOfEnergyConsumedId : sumOfEnergyConsumed ?? 0,
      DBConfig.ampereId : ampere ?? 0,
      DBConfig.voltageId : volt ?? 0,
    }..addEntries(deviceData?.toJson().entries ?? [])
     ..addEntries(boundData?.toJson().entries ?? []);
  }

}