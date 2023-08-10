
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/repo/monitoring_device_repo_model.dart';

class SumOfElectricityConsumptionDataModel implements RepoModel{
  // Device electricity consumption data model 
  @override
  String index = DBConfig.deviceConsumptionSumRepoIndex;

  @override
  String? repoId; // db: _id
  final int? dayConsumption; // db:  _source/d_con
  final int? monthConsumption; // db:  _source/m_con
  final int? yearConsumption; // db:  _source/y_con
  final int? quarterConsumption; // db:  _source/q_con
  final double? averageMonthConsumptionPerMonth; //  _source/avg_m_h_com;
  final DateTime? dateTime; // db:  _source/datetime
  final MonitoringDeviceModel? deviceData;
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
  });
  
  factory SumOfElectricityConsumptionDataModel.getInstance() => SumOfElectricityConsumptionDataModel();

  @override
  String toString() {
    return toJson().entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }

  @override
  SumOfElectricityConsumptionDataModel fromJson(Map<String, dynamic> json) {
    try{
      var source = json['_source'];
      return SumOfElectricityConsumptionDataModel( 
      dayConsumption: source['d_con'] as int,
      monthConsumption: source['m_con'] as int,
      yearConsumption: source['y_con'] as int,
      quarterConsumption: source['q_con'] as int,
      averageMonthConsumptionPerMonth: source['avg_m_h_con'] as double,
      dateTime: DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(source['datetime'] as String),
      deviceData: MonitoringDeviceModel(
        tagId: source['tagid'] as String,
        loc: source['loc'] as String,
        building: source['building'] as String,
        assetType: source['assettype'] as String,
        lineType: source['linetype'] as String,
        department: source['department'] as String,
      ),
      repoId: json['_id'] as String,
    );
    } catch(e){
      debugPrint(json.toString());
      debugPrint(e.toString());
      rethrow;
    }
    
  }

  @override
  Map<String, dynamic> toJson() {
    return{
      'd_con': dayConsumption,
      'm_con': monthConsumption,
      'avg_m_h_con': averageMonthConsumptionPerMonth,
      'y_con': yearConsumption,
      'q_con': quarterConsumption,
      'datetime': dateTime?.toIso8601String(),
      'tagid': deviceData?.tagId,
      'loc': deviceData?.loc,
      'building': deviceData?.building,
      'assettype': deviceData?.assetType,
      'linetype': deviceData?.lineType,
      'department': deviceData?.department,
    };
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

  static List<PieChartProportion<SumOfElectricityConsumptionDataModel>> fromSumOfConsumption(List<SumOfElectricityConsumptionDataModel> dataSource){
    List<PieChartProportion<SumOfElectricityConsumptionDataModel>> result = [];
    // debugPrint(dataSource.toString());
    int total = 0;
    for(int i = 0; i < dataSource.length; i++){
      total += dataSource[i].dayConsumption ?? 0;
    }
    for(int i = 0; i < dataSource.length; i++){
      result.add(PieChartProportion(
        model: dataSource[i],
        amount: dataSource[i].dayConsumption ?? 0,
        proportion: (dataSource[i].dayConsumption ?? 0) / total * 100,
      ));
    }
    return result;
  }
}