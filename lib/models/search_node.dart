import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';

abstract class SearchTreeNode<T>{
  String index;
  T? data;
  List<SearchTreeNode> children = [];
  SearchTreeNode({
    required this.index,
    required this.children,
    this.data,
  });
  factory SearchTreeNode.buildTree(List<T> data, List<String> indexList) => throw UnimplementedError();

  void printTree({int depth=0}){
    debugPrint("${'|--' * depth}${toString()}");
    if(children.isNotEmpty){
      for(var node in children){
        node.printTree(depth: depth+1);
      }
    }
  }

  SearchTreeNode? searchTree(List<String> indexes){
    if(indexes.isEmpty) return null;
    String target = indexes.first;
    if(index == target){
      indexes.removeAt(0);
      if(indexes.isEmpty){
        // debugPrint("Found [$index] : ${toString()}");
        return this;
      }else{
        return searchTree(indexes);
      } 
    }else{
      for(SearchTreeNode node in children){
        var r = node.searchTree(indexes);
        if(r != null){
          return r;
        }
      }
    }
    return null;
  }

  List<T> toList(){
    List<T> result = [];
    if(data!=null){
       result.add(data as T);
    }
    for(SearchTreeNode node in children){
      result.addAll(node.toList() as List<T>)  ;
    }
    return result;
  } 

  List<PieChartProportion> toProportionList();
  @override
  String toString() {
    // TODO: implement toString
    return "[$index]";
  }
}

class ConsumptionSearchNode extends SearchTreeNode<SumOfElectricityConsumptionDataModel>{
  ConsumptionSearchNode({
    required super.index,
    required super.children,
    super.data,
  });

  @override
  String toString() =>  "[$index] : $dayConsumption";

  int get dayConsumption 
    => data?.dayConsumption ?? 0 + children.fold<int>(0, (previousValue, element) => previousValue + (element as ConsumptionSearchNode).dayConsumption);
  int get monthConsumption
    => data?.monthConsumption ?? 0 + children.fold<int>(0, (previousValue, element) => previousValue + (element as ConsumptionSearchNode).monthConsumption);
  int get yearConsumption
    => data?.yearConsumption ?? 0 + children.fold<int>(0, (previousValue, element) => previousValue + (element as ConsumptionSearchNode).yearConsumption);
  int get quarterConsumption
    => data?.quarterConsumption ?? 0 + children.fold<int>(0, (previousValue, element) => previousValue + (element as ConsumptionSearchNode).quarterConsumption);
  double get averageMonthConsumptionPerMonth
    => data?.averageMonthConsumptionPerMonth ?? 0 + children.fold<double>(0, (previousValue, element) => previousValue + (element as ConsumptionSearchNode).averageMonthConsumptionPerMonth);

  DateTime get dateTime
    => data?.dateTime ?? children.fold<DateTime>(DateTime.now(), (previousValue, element) => previousValue = (element as ConsumptionSearchNode).dateTime);

  @override
  factory ConsumptionSearchNode.buildTree({
    required List<SumOfElectricityConsumptionDataModel> data,
    required List<String> indexes,
  }){
    List<ConsumptionSearchNode> d = data.map((data)
      => ConsumptionSearchNode(index: data.deviceData?.tagId ?? "", data: data, children: [])).toList();
    return ConsumptionSearchNode.groupDataByIndex(d, indexes);
  }
  static ConsumptionSearchNode groupDataByIndex(List<ConsumptionSearchNode> data,List<String> indexes){ 
    String index = indexes.removeAt(0);
    final candidateList = data.map<String>((ConsumptionSearchNode node) => node.data!.getDataByKey(index)).toSet().toList();
    List<ConsumptionSearchNode> tempGroup = [];
    for (String candidate in candidateList){
      var tempData = data.where((node) => node.data!.getDataByKey(index) == candidate).toList();
      tempGroup.add(
        ConsumptionSearchNode(
          index: candidate, 
          children: 
            indexes.isEmpty 
            ? tempData
            : [groupDataByIndex(tempData, List.from(indexes))]
        )
      );
    }    
    return ConsumptionSearchNode(
      index: index, 
      children: tempGroup
    );
  }
  
  @override
  List<PieChartProportion<ConsumptionSearchNode>> toProportionList() {
    List<PieChartProportion<ConsumptionSearchNode>> result = [];
    int total = (children as List<ConsumptionSearchNode>).fold<int>(0, (previousValue,  element) => previousValue + element.dayConsumption);
    for(ConsumptionSearchNode child in children as List<ConsumptionSearchNode>){
      result.add(PieChartProportion(
        model: child,
        amount: child.dayConsumption,
        proportion: (child.dayConsumption) / total * 100,
      ));
    }
    return result;
  }
}

