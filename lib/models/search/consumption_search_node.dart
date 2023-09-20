import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search/search_node.dart';

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
  double get billPrice 
    => data?.dayBillPrice ?? 0.0 + children.fold<double>(0, (previousValue, element) => previousValue + (element as ConsumptionSearchNode).billPrice);  

  DateTime get dateTime
    => data?.dateTime ?? children.fold<DateTime>(DateTime.now(), (previousValue, element) => previousValue = (element as ConsumptionSearchNode).dateTime);

  double get averageBillPerUnit => billPrice / dayConsumption;
  
  @override
  factory ConsumptionSearchNode.buildTree({
    required List<SumOfElectricityConsumptionDataModel> data,
    List<String>? indexes,
  }){
    List<ConsumptionSearchNode> d = data.map((data)
      => ConsumptionSearchNode(index: data.deviceData?.tagId ?? "", data: data, children: [])).toList();
    return ConsumptionSearchNode(
        index: 'all', 
        children: 
          indexes == null || indexes.isEmpty 
          ? d
          : [groupDataByIndex(d, indexes)]
    );
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
  
  // @override
  // List<PieChartProportion<ConsumptionSearchNode>> toProportionList({required num Function(SearchTreeNode) builder}) {
  //   List<PieChartProportion<ConsumptionSearchNode>> result = [];
  //   var data = children.map(builder).toList();
  //   num total = data.fold<num>(0, (previousValue,  element) => previousValue + element);
  //   for(ConsumptionSearchNode child in children as List<ConsumptionSearchNode>){
  //     result.add(PieChartProportion(
  //       model: child,
  //       amount: child.dayConsumption,
  //       proportion: (child.dayConsumption) / total * 100,
  //     ));
  //   }
  //   return result;
  // }
  
  @override
  void addNewGroup({
    required String index, 
    required String Function(SearchTreeNode node) indexBuilder,
  }){
    if (children.isEmpty) return;
    if (children.first.data==null){
      for(SearchTreeNode node in children){
        node.addNewGroup(index: index, indexBuilder: indexBuilder);
      }
      return;
    }
    else{
      final candidateList = children.map<String>((node) => indexBuilder(node)).toSet().toList();
      List<ConsumptionSearchNode> tempGroup = [];
      for (String candidate in candidateList){
        var tempData = children.where((node) => indexBuilder(node) == candidate).toList();
        tempGroup.add(
          ConsumptionSearchNode(
            index: candidate, 
            children: tempData
          )
        );
      }
      children = [ConsumptionSearchNode(
        index: index, 
        children: tempGroup
      )];
    }
  }
}

