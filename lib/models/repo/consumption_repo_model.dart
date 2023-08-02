
import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';

class ElectricityConsumptionDataModel implements RepoModel{
  // Device electricity consumption data model 
  @override
  String index = DBConfig.deviceConsumptionRepoIndex;

  @override
  String? repoId; // db: _id

  final DateTime? startTime; // db: datetime
  final String? loc; // db: loc 
  final String? building; // db: building
  final int? power; // db: kw
  final int? energyConsumed; // db: kwh
  final int? sumOfEnergyConsumed; // db: sum_kwh
  final int? ampere; // db: ampere
  final int? volt; // db: voltage
  // constructor
  ElectricityConsumptionDataModel({
    this.startTime,
    this.loc,
    this.building,
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
    // debugPrint(json.toString());
    return ElectricityConsumptionDataModel(
      startTime: DateTime.parse(json['_source']['datetime'] as String),
      loc: json['_source']['loc'] as String ,
      building: json['_source']['building'] as String,
      power: json['_source']['kw'],
      energyConsumed: json['_source']['kwh'],
      sumOfEnergyConsumed: json['_source']['sum_kwh'],
      ampere: json['_source']['ampere'],
      volt: json['_source']['voltage'],
      repoId: json['_id'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'datetime': startTime?.toIso8601String(),
      'loc': loc,
      'building': building,
      'kw': power,
      'kwh': energyConsumed,
      'sum_kwh': sumOfEnergyConsumed,
      'ampere': ampere,
      'voltage': volt,
    };
  }

}