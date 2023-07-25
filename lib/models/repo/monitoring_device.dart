class MonitoringDeviceModel{
  final String loc;
  final String building;
  final String tagId;
  final String? groupId;
  final String? description;

  MonitoringDeviceModel({
    required this.loc,
    required this.building,
    required this.tagId,
    this.groupId,
    this.description
  });

  factory MonitoringDeviceModel.fromJson(Map<String, dynamic> json) {
    return MonitoringDeviceModel(
      loc: json['loc'],
      building: json['building'],
      tagId: json['tagId'],
      groupId: json['groupId'],
      description: json['description']
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return "loc: $loc, name: $building, tagId: $tagId, groupId: $groupId, description: $description"; 
  }

}