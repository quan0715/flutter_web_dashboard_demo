
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';

class SumOfElectricityConsumptionDataModel implements RepoModel{
  // Device electricity consumption data model 
  @override
  String index = DBConfig.deviceConsumptionSumRepoIndex;

  @override
  String? repoId; // db: _id
  final String? tagId; // db:  _source/tagid
  final int? dayConsumption; // db:  _source/d_com
  final int? monthConsumption; // db:  _source/m_com
  final int? averageMonthConsumptionPerMonth; //  _source/avg_m_h_com;
  // constructor
  SumOfElectricityConsumptionDataModel({
    this.tagId,
    this.dayConsumption,
    this.monthConsumption,
    this.averageMonthConsumptionPerMonth,
    this.repoId,
  });

  factory SumOfElectricityConsumptionDataModel.getInstance() => SumOfElectricityConsumptionDataModel();

  @override
  SumOfElectricityConsumptionDataModel fromJson(Map<String, dynamic> json) {
    return SumOfElectricityConsumptionDataModel( 
      tagId: json['_source']['tagid'] as String,
      dayConsumption: json['_source']['d_com'] as int,
      monthConsumption: json['_source']['m_com'] as int,
      averageMonthConsumptionPerMonth: json['_source']['avg_m_h_com'] as int,
      repoId: json['_id'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'tagid': tagId,
      'd_com': dayConsumption,
      'm_com': monthConsumption,
      'avg_m_h_com': averageMonthConsumptionPerMonth,
    };
  }

}