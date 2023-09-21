import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/base_repo.dart';

class ConfigRepoModel implements RepoModel{

  @override
  String index = DBConfig.dashboardConfigRepoIndex;
  
  @override
  String? repoId;

  int? scadaIntervalPerMin; // scada_interval_per_min 
  int? priceRateContractCapacity; // price_rate_contract_capacity
  RateSectionType? priceRateSectionType; // price_rate_section_type
  RateType? priceRateType; // price_rate_type
  RateVoltageType? priceRateVoltageType; // price_rate_voltage_type

  ConfigRepoModel({
    this.scadaIntervalPerMin,
    this.priceRateContractCapacity,
    this.priceRateSectionType,
    this.priceRateType,
    this.priceRateVoltageType,
    this.repoId,
  });

  factory ConfigRepoModel.getInstance() => ConfigRepoModel();

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
  
  @override
  RepoModel? fromJson(Map<String, dynamic> json) {
    var s = json['_source'];
    return ConfigRepoModel(
      scadaIntervalPerMin: s['scada_interval_per_min'],
      priceRateContractCapacity: s['price_rate_contract_capacity'],
      priceRateSectionType: RateSectionType.fromValue(s['price_rate_section_type']),
      priceRateType: RateType.fromValue(s['price_rate_type']),
      priceRateVoltageType: RateVoltageType.fromValue(s['price_rate_voltage_type']),
      repoId: json['_id'] as String,
    );
  }
  
  @override
  Map<String, dynamic>? toJson() {
    return {
      'scada_interval_per_min': scadaIntervalPerMin,
      'price_rate_contract_capacity': priceRateContractCapacity,
      'price_rate_section_type': priceRateSectionType?.value,
      'price_rate_type': priceRateType?.value,
      'price_rate_voltage_type': priceRateVoltageType?.value,
    };
  }
}

enum RateSectionType{
  twoStep('兩階段', 'two_section'), threeStep('三階段', 'three_section'), non('non', 'non');
  final String label;
  final String value;
  const RateSectionType(this.label, this.value);
  factory RateSectionType.fromValue(String value){
    switch(value){
      case 'two_section':
        return RateSectionType.twoStep;
      case 'three_section':
        return RateSectionType.threeStep;
      default:
        return RateSectionType.non;
    }
  }
}

enum RateType{
  fixed('fix 固定時段', 'fix'), dynamic('Dynamic 動態時段', 'dynamic'), non('non', 'non');
  final String label;
  final String value;
  const RateType(this.label, this.value);
  factory RateType.fromValue(String value){
    switch(value){
      case 'fix':
        return RateType.fixed;
      case 'dynamic':
        return RateType.dynamic;
      default:
        return RateType.non;
    }
  }
}

enum RateVoltageType{
  hv('高壓電 HV', 'hv'), uhv('超高壓電 UHV', 'uhv'), non('non', 'non');
  final String label;
  final String value;
  const RateVoltageType(this.label, this.value);
  factory RateVoltageType.fromValue(String value){
    switch(value){
      case 'hv':
        return RateVoltageType.hv;
      case 'uhv':
        return RateVoltageType.uhv;
      default:
        return RateVoltageType.non;
    }
  }
}

