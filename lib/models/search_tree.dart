import 'package:flutter/material.dart';
import 'package:web_dashboard/models/group_consumption_data_model.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';

class ConsumptionSearchTree{
  final SumOfElectricityConsumptionDataModel? root;
  ConsumptionSearchTree({this.root});

  factory ConsumptionSearchTree.buildTree(List<SumOfElectricityConsumptionDataModel> data, List<String> indexList){
    return ConsumptionSearchTree(root: groupDataByIndex(data, indexList));
  }

  void print({int depth=0}){
    if(root != null){
      ConsumptionSearchTree.printTree(root as DeviceGroupModel, depth: depth);
    }
    else{
      debugPrint("Empty tree");
    }
  }

  List<SumOfElectricityConsumptionDataModel> toDataList(){
    if(root != null){
      return ConsumptionSearchTree.toList(root as DeviceGroupModel);
    }
    else{
      debugPrint("Empty tree");
      return [];
    }
  }

  ConsumptionSearchTree? searchByIndex(List<String> indexList){
    var result = ConsumptionSearchTree.searchTree(root as DeviceGroupModel, indexList);
    if(result != null){
      return ConsumptionSearchTree(root: result);
    }
    debugPrint("Not found");
    return null;
  }  


  static printTree(DeviceGroupModel root,{int depth=0}){
    for(SumOfElectricityConsumptionDataModel l in root.dataSource){
      if(l is DeviceGroupModel){
        debugPrint("${'|--' * depth}Group ${l.groupLabel} : ${l.dayConsumption}");
        printTree(l, depth: depth+1);
      }else{
        debugPrint("${'|--' * depth} ${l.deviceData?.tagId ?? l.groupLabel} : ${l.dayConsumption}");
      }
    }
  }

  static SumOfElectricityConsumptionDataModel? searchTree(SumOfElectricityConsumptionDataModel root, List<String> labels){
    String label = labels.first;
    for(SumOfElectricityConsumptionDataModel l in (root as DeviceGroupModel).dataSource){
      if(l.groupLabel == label){
        labels.removeAt(0);
        if(labels.isEmpty){
          // debugPrint("Found ${l.groupLabel} : ${l.dayConsumption}");
          return l;
        }else{
          return searchTree(l, labels);
        } 
      }
      if(l is DeviceGroupModel){
        var r = searchTree(l, labels);
        if(r != null){
          return r;
        }
      }
    }
    return null;
  }

  static SumOfElectricityConsumptionDataModel groupDataByIndex(List<SumOfElectricityConsumptionDataModel> data,List<String> indexList){ 
    String index = indexList.removeAt(0);
    final candidateList = data.map<String>((e) => e.getDataByKey(index)).toSet().toList();
    List<SumOfElectricityConsumptionDataModel> tempGroup = [];
    for (String candidate in candidateList){
      var tempData = data.where((element) => element.getDataByKey(index) == candidate).toList();
      tempGroup.add(
        DeviceGroupModel(
          groupLabel: candidate, 
          dataSource: 
            indexList.isEmpty 
            ? tempData
            : [groupDataByIndex(tempData, List.from(indexList))]
          )
        );
    }    
    return DeviceGroupModel( groupLabel: index, dataSource: tempGroup);
  }

  static List<SumOfElectricityConsumptionDataModel> toList(SumOfElectricityConsumptionDataModel root){
    List<SumOfElectricityConsumptionDataModel> result = [];
    if(root is DeviceGroupModel){
      for(SumOfElectricityConsumptionDataModel l in root.dataSource){
        result.addAll(toList(l));
      }
    }else{
      result.add(root);
    }
    return result;
  }
  
}