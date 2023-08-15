import 'package:web_dashboard/db/db_config.dart';

class DeviceDataClass {
  final String? tagId;
  final String? loc;
  final String? building;
  final String? assetType;
  final String? lineType;
  final String? department;
  final String? description;

  DeviceDataClass({
    this.tagId,
    this.loc,
    this.building,
    this.assetType,
    this.lineType,
    this.department,
    this.description,
  });

  @override
  String toString() {
    return "| tagId: $tagId | lineType: $lineType | department: $department | description: $description |";
  }

  factory DeviceDataClass.fromJson(Map<String, dynamic> json){
    return DeviceDataClass(
      tagId: json[DBConfig.tagIdId] ?? "empty",
      loc: json[DBConfig.locId] ?? "empty",
      building: json[DBConfig.buildingId] ?? "empty",
      assetType: json[DBConfig.assetTypeId] ?? "empty",
      lineType: json[DBConfig.lineTypeId] ?? "empty",
      department: json[DBConfig.departmentId] ?? "empty",
      description: json[DBConfig.descriptionId] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    DBConfig.tagIdId: tagId ?? "",
    DBConfig.locId: loc ?? "",
    DBConfig.buildingId: building ?? "",
    DBConfig.assetTypeId: assetType ?? "",
    DBConfig.lineTypeId: lineType ?? "",
    DBConfig.departmentId: department ?? "",
    DBConfig.descriptionId: description ?? "",
  };

}