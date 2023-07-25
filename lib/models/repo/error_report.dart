class ErrorReportModel{
  final ElectricityConsumptionErrorType? errorType;
  final String? errorDescription;
  final DateTime? startTime;
  final String? loc;
  final String? building;
  final String? tagId;
  final int? ampere;
  final int? volt;
  final int? power;
  // constructor
  ErrorReportModel({
    this.errorType,
    this.errorDescription,
    this.startTime,
    this.loc,
    this.building,
    this.tagId,
    this.ampere,
    this.volt,
    this.power
  });
  factory ErrorReportModel.fromJson(Map<String, dynamic> json){
    return ErrorReportModel(
      errorType: json['errorType'],
      errorDescription: json['errorDescription'],
      startTime: json['startTime'],
      loc: json['loc'],
      building: json['building'],
      tagId: json['tagId'],
      ampere: json['ampere'],
      volt: json['volt'],
      power: json['power']
    );
  }
}

enum ElectricityConsumptionErrorType{
  sharplyIncrease, sharplyDecrease, abnormal, other;
  
}