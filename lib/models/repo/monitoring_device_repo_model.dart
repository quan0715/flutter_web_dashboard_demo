import 'package:web_dashboard/models/data/bound_data_class.dart';
import 'package:web_dashboard/models/base_repo.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/data/device_data_class.dart';
class MonitoringDeviceModel implements RepoModel{
  @override
  String index = DBConfig.meterRepoIndex;

  @override
  String? repoId;
  final String? changeBy;
  final DateTime? changeDate;
  final DeviceDataClass? device;
  final BoundDataClass? boundData;
  
  MonitoringDeviceModel({
	  this.device,
	  this.changeBy,
	  this.changeDate,
    this.boundData,
    this.repoId,
	});
  
  factory MonitoringDeviceModel.getInstance() => MonitoringDeviceModel();


  @override
  MonitoringDeviceModel fromJson(Map<String, dynamic> json) {
    var s = json['_source'];
    // use DBConfig.meterRepoIndex instead of index
    return MonitoringDeviceModel(
      device: DeviceDataClass.fromJson(s),
      changeBy: s[DBConfig.changeById],
      changeDate: DBConfig.dateFormat.parse(s[DBConfig.changeDateId]),
      boundData: BoundDataClass.fromJson(s),
      repoId: json['_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
	  return <String, dynamic>{
      DBConfig.changeById: changeBy ?? '',
      DBConfig.changeDateId: changeDate?.toIso8601String() ?? '',
	  }
    ..addEntries(boundData?.toJson().entries ?? [])
    ..addEntries(device?.toJson().entries ?? []);
	}
  
  String getDataByKey(String key){
    var map = toJson();
    if(map.containsKey(key)){
      return map[key].toString();
    }else{
      return device!.getDataByKey(key);
    }
  }
}
