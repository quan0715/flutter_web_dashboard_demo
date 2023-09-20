
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/data/device_data_class.dart';

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
   double? dayBillPrice; // db:  _source/bill
   double? monthBillPrice;
   double? quarterBillPrice;
   double? yearBillPrice;   
  // constructor
  SumOfElectricityConsumptionDataModel({
    this.dayConsumption,
    this.monthConsumption,
    this.averageMonthConsumptionPerMonth,
    this.yearConsumption,
    this.quarterConsumption,
    this.deviceData,
    this.dateTime,
    this.dayBillPrice,
    this.monthBillPrice,
    this.quarterBillPrice,
    this.yearBillPrice,
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
      dayConsumption: s[DBConfig.dayConsumptionId].toInt(),
      monthConsumption: s[DBConfig.monthConsumptionId].toInt(),
      yearConsumption: s[DBConfig.yearConsumptionId].toInt(),
      quarterConsumption: s[DBConfig.quarterConsumption],
      averageMonthConsumptionPerMonth: s[DBConfig.averageMonthConsumptionPerMonth],
      dateTime: DBConfig.dateFormat.parse(s[DBConfig.dateTimeId]),
      deviceData: DeviceDataClass.fromJson(s),
      dayBillPrice: s[DBConfig.billId] ?? 0,
      monthBillPrice: s[DBConfig.monthBillId] ?? 0,
      quarterBillPrice: s[DBConfig.quarterBillId] ?? 0,
      yearBillPrice: s[DBConfig.yearBillId] ?? 0,
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
      DBConfig.billId: dayBillPrice ?? 0,
      DBConfig.monthBillId: monthBillPrice ?? 0,
      DBConfig.yearBillId: yearBillPrice ?? 0,
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

class PieChartProportion{
  // for pie chart
  final String index;
  final int amount;
  final double proportion;
  PieChartProportion({
    required this.index,
    required this.amount,
    required this.proportion,
  });

  static List<PieChartProportion> listBuilder<T>({
    required List<T> dataSource,
    required num Function(T node) valueBuilder,
    required String Function(T node) indexBuilder,
  }){
    List<PieChartProportion> result = [];
    var total = dataSource.fold(0, (previousValue, element) => previousValue + valueBuilder(element).toInt());
    for (T data in dataSource){
      result.add(
        PieChartProportion(
          index: indexBuilder(data),
          amount: valueBuilder(data).toInt(),
          proportion: valueBuilder(data) / total * 100,
        )
      );
    }
    return result;
  }
}