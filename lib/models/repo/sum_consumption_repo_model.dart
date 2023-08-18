
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/repo/device_data_class.dart';

class SumOfElectricityConsumptionDataModel implements RepoModel{
  // Device electricity consumption data model 
  @override
  String index = DBConfig.deviceConsumptionSumRepoIndex;
  String groupLabel = "";

  @override
  String? repoId; // db: _id
   int? dayConsumption; // db:  _source/d_con
   int? monthConsumption; // db:  _source/m_con
   int? yearConsumption; // db:  _source/y_con
   int? quarterConsumption; // db:  _source/q_con
   double? averageMonthConsumptionPerMonth; //  _source/avg_m_h_com;
   DateTime? dateTime; // db:  _source/datetime
   DeviceDataClass? deviceData;
  // constructor
  SumOfElectricityConsumptionDataModel({
    this.dayConsumption,
    this.monthConsumption,
    this.averageMonthConsumptionPerMonth,
    this.yearConsumption,
    this.quarterConsumption,
    this.deviceData,
    this.dateTime,
    this.repoId,
  }){
    groupLabel = deviceData?.tagId ?? '';
  }
  
  factory SumOfElectricityConsumptionDataModel.getInstance() => SumOfElectricityConsumptionDataModel();

  @override
  SumOfElectricityConsumptionDataModel fromJson(Map<String, dynamic> json) {
    try{
      var s = json['_source'];
      return SumOfElectricityConsumptionDataModel( 
      dayConsumption: s[DBConfig.dayConsumptionId],
      monthConsumption: s[DBConfig.monthConsumptionId],
      yearConsumption: s[DBConfig.yearConsumptionId],
      quarterConsumption: s[DBConfig.quarterConsumption],
      averageMonthConsumptionPerMonth: s[DBConfig.averageMonthConsumptionPerMonth],
      dateTime: DBConfig.dateFormat.parse(s[DBConfig.dateTimeId]),
      deviceData: DeviceDataClass.fromJson(s),
      repoId: json['_id'] as String,
    );
    } catch(e){
      debugPrint(DBConfig.jsonSerializerMessage(index, "$e\n$json"));
      rethrow;
    }
    
  }

  @override
  Map<String, dynamic> toJson() {
    return{
      DBConfig.dayConsumptionId: dayConsumption ?? 0,
      DBConfig.monthConsumptionId: monthConsumption ?? 0,
      DBConfig.averageMonthConsumptionPerMonth: averageMonthConsumptionPerMonth ?? 0,
      DBConfig.yearConsumptionId: yearConsumption ?? 0,
      DBConfig.quarterConsumption: quarterConsumption ?? 0,
      DBConfig.dateTimeId: dateTime?.toIso8601String() ?? '',
    }..addEntries(deviceData?.toJson().entries ?? []);
  }

  String getDataByKey(String key){
    var map = toJson();
    if(map.containsKey(key)){
      return map[key].toString();
    }else{
      return deviceData!.getDataByKey(key);
    }
  }
}

class PieChartProportion<M>{
  // for pie chart
  final M model;
  final int amount;
  final double proportion;
  PieChartProportion({
    required this.model, 
    required this.amount,
    required this.proportion,
  });
}