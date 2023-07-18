import 'package:flutter/material.dart';
import 'package:prologium_project_demo/models/electricity_amount_proportion.dart';
import 'package:prologium_project_demo/models/electricity_flow_data.dart';
import 'package:prologium_project_demo/models/emmission_time_data.dart';
import 'package:prologium_project_demo/models/error_report_model.dart';
import 'package:prologium_project_demo/models/workspace_model.dart';

class AmmeterModel{
  
  String ammeterId;
  String name;
  String location;
  String description;
  String label;

  ElectricityFlowData? data;
  List<AmmeterModel> subAmmeters = [];
  WorkspaceType workspaceType;

  AmmeterModel({
    required this.ammeterId,
    required this.name,
    required this.workspaceType,
    this.data,
    this.subAmmeters = const [],
    this.location = "",
    this.description = "",
    this.label = "",
  });

  
  bool get haveSubAmmeters => subAmmeters.isNotEmpty;
  
  List<ElectricityAmountProportion> get getProportion{
    if(haveSubAmmeters){
      List<ElectricityAmountProportion> result = [];
      int currentElectricityFlow = ammeterData.currentElectricityFlow;
      for(AmmeterModel child in subAmmeters){
        result.add(ElectricityAmountProportion(
          name: child.name,
          proportion: child.ammeterData.currentElectricityFlow / currentElectricityFlow,
          amount: child.ammeterData.currentElectricityFlow
        ));
      }
      debugPrint("result: $result");
      return result;
    }
    return [];
  }


  ElectricityFlowData get ammeterData 
    => data != null 
      ? data! 
      : ElectricityFlowData(
          weaklyAccumulatedElectricityFlow: weaklyAccumulatedElectricityFlow,
          lastWeaklyAccumulatedElectricityFlow: lastWeaklyAccumulatedElectricityFlow,
          monthlyAccumulatedElectricityFlow: subAmmeters.map((e) => e.ammeterData.monthlyAccumulatedElectricityFlow).reduce((value, element) => value + element),
          lastMonthlyAccumulatedElectricityFlow: subAmmeters.map((e) => e.ammeterData.lastMonthlyAccumulatedElectricityFlow).reduce((value, element) => value + element),
      );  
      
  List<EmissionTimeData> get weaklyAccumulatedElectricityFlow{
    if(data != null) return data!.weaklyAccumulatedElectricityFlow;
    List<EmissionTimeData> result = [];
    for(AmmeterModel child in subAmmeters){
      List<EmissionTimeData> data = child.weaklyAccumulatedElectricityFlow;
      if(result.isEmpty) {
        result.addAll(data);
      } else{
        for(int i = 0; i < result.length; i++){
          result[i] = EmissionTimeData(
            time: result[i].time,
            amount: result[i].amount + data[i].amount
          );
        }
      }
    }
    
    return result;
  }

  List<EmissionTimeData> get lastWeaklyAccumulatedElectricityFlow{
    if(data != null) return data!.lastWeaklyAccumulatedElectricityFlow;
    List<EmissionTimeData> result = [];
    for(AmmeterModel child in subAmmeters){
      List<EmissionTimeData> data = child.lastWeaklyAccumulatedElectricityFlow;
      if(result.isEmpty) {
        result.addAll(data);
      } else{
        for(int i = 0; i < result.length; i++){
          result[i] = EmissionTimeData(
            time: result[i].time,
            amount: result[i].amount + data[i].amount
          );
        }
      }
    }
    
    return result;
  }
}

