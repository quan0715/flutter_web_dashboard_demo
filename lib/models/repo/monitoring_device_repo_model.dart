import 'package:web_dashboard/models/repo/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';
class MonitoringDeviceModel implements RepoModel{
  @override
  String index = DBConfig.meterRepoIndex;

  @override
  String? repoId;
  
  final String? loc;
  final String? building;
  final String? tagId;
  final String? assetType;
  final String? lineType;
  final String? department;
  final String? description;
  final String? changeBy;
  final DateTime? changeDate;
  final int? lb;  // lower bound
  final int? ub;  // upper bound
  final int? wub; // warning upper bound
  final int? wlb; // warning lower bound
  

  MonitoringDeviceModel({
	  this.loc,
	  this.building,
	  this.tagId,
	  this.assetType,
    this.lineType,
    this.department,
	  this.description,
	  this.changeBy,
	  this.changeDate,
    this.lb,
    this.ub,
    this.wub,
    this.wlb,
    this.repoId,
	});

  @override
  String toString() {
    // TODO: implement toString
    return "loc: $loc, building: $building, tagId: $tagId, assetType: $assetType, lineType: $lineType department: $department description: $description, changeBy: $changeBy, changeDate: ${changeDate?.toIso8601String()}, repoId: $repoId";
  }
  
  factory MonitoringDeviceModel.getInstance(){
    return MonitoringDeviceModel();
  }

  @override
  MonitoringDeviceModel fromJson(Map<String, dynamic> json) {
    return MonitoringDeviceModel(
      loc: json['_source']['loc'],
      building: json['_source']['building'],
      tagId: json['_source']['tagid'],
      assetType: json['_source']['assettype'],
      lineType: json['_source']['linetype'],
      department: json['_source']['department'],
      description: json['_source']['desc'],
      changeBy: json['_source']['changeby'],
      changeDate: DateTime.parse(json['_source']['changetime'] as String),
      lb: json['_source']['lb'],
      ub: json['_source']['ub'],
      wub: json['_source']['wub'],
      wlb: json['_source']['wlb'],
      repoId: json['_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
		// turn all null value to empty string
		return <String, dynamic>{
			"loc": loc ?? "",	
			"building": building ?? "",
			"tagid": tagId ?? "",
			"assettype": assetType ?? "",
      "linetype": lineType ?? "",
      "department": department ?? "",
			"desc": description ?? "",
			"changeby": changeBy ?? "",
      "lb" : lb ?? 0,
      "ub" : ub ?? 0,
      "wub" : wub ?? 0,
      "wlb" : wlb ?? 0,
			"changetime": changeDate?.toIso8601String() ?? "",
		};
	}
  
}
