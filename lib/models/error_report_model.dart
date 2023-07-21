import 'package:web_dashboard/models/ammeter_model.dart';

class AmmeterErrorReportModel{
  // String AmmeterLocation;
  AmmeterModel ammeter;

  DateTime startTime;
  Duration duration;
  
  int electricityConsumed;
  int averageElectricityConsumed;

  AmmeterErrorReportModel({
    required this.ammeter,
    required this.startTime,
    required this.duration,
    required this.electricityConsumed,
    required this.averageElectricityConsumed
  });

  // String get ammeterName => ammeter.name;
  // String get ammeterLocation => ammeter.location;
  // String get ammeterDescription => ammeter.description;
  // String get ammeterId => ammeter.id;
  
  int get electricityConsumedPercentage =>
     (((electricityConsumed - averageElectricityConsumed) / averageElectricityConsumed) * 100).toInt();

  String getErrorType(){
    int percentage = electricityConsumedPercentage;
    // debugPrint(percentage.toString());
    if(percentage > 20){
      return "突增";
    }else if(percentage < -20){
      return "突降";
    }else{
      return "正常";
    }
  }
}