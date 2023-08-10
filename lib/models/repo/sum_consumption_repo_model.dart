
import 'package:intl/intl.dart';
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';
// sample data: 
// tagid: G1_M30_MACS_MACS0002_KWH
// d_com: 25, m_com: 182
// avg_m_h_com: 22.75
// datetime: 2023-08-08T00:00:00.000+0800
// loc: G1
// building: M30
// assettype: MACS


class SumOfElectricityConsumptionDataModel implements RepoModel{
  // Device electricity consumption data model 
  @override
  String index = DBConfig.deviceConsumptionSumRepoIndex;

  @override
  String? repoId; // db: _id
  final String? tagId; // db:  _source/tagid
  final int? dayConsumption; // db:  _source/d_com
  final int? monthConsumption; // db:  _source/m_com
  final double? averageMonthConsumptionPerMonth; //  _source/avg_m_h_com;
  final DateTime? dateTime; // db:  _source/datetime
  final String? loc; // db:  _source/loc
  final String? building; // db:  _source/building
  final String? assetType; // db:  _source/assettype
   
  // constructor
  SumOfElectricityConsumptionDataModel({
    this.tagId,
    this.dayConsumption,
    this.monthConsumption,
    this.averageMonthConsumptionPerMonth,
    this.dateTime,
    this.loc,
    this.building,
    this.assetType,
    this.repoId,
  });
  
  factory SumOfElectricityConsumptionDataModel.getInstance() => SumOfElectricityConsumptionDataModel();

  @override
  SumOfElectricityConsumptionDataModel fromJson(Map<String, dynamic> json) {
    // print(json['_source']['datetime'].toString());
    // print(DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(json['_source']['datetime'] as String));
    try{
      return SumOfElectricityConsumptionDataModel( 
      tagId: json['_source']['tagid'] as String,
      dayConsumption: json['_source']['d_com'] as int,
      monthConsumption: json['_source']['m_com'] as int,
      averageMonthConsumptionPerMonth: json['_source']['avg_m_h_com'] as double,
      // dateTime: DateTime.parse(json['_source']['datetime']),
      dateTime: DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(json['_source']['datetime'] as String),
      loc: json['_source']['loc'] as String,
      building: json['_source']['building'] as String,
      assetType: json['_source']['assettype'] as String,
      repoId: json['_id'] as String,
    );
    } catch(e){
      print(json.toString());
      print(e.toString());
      throw e;
    }
    
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'tagid': tagId,
      'd_com': dayConsumption,
      'm_com': monthConsumption,
      'avg_m_h_com': averageMonthConsumptionPerMonth,
      'datetime': dateTime?.toIso8601String(),
      'loc': loc,
      'building': building,
      'assettype': assetType,
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