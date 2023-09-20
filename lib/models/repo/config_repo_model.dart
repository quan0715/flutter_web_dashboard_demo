import 'package:flutter/material.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/base_repo.dart';
import 'package:web_dashboard/models/data/config.dart';

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