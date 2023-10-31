import 'package:web_dashboard/models/data/filter_data_class.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search/search_node.dart';

class FilterSearchTreeNode extends SearchTreeNode<LayerFilterData<String>>{
  FilterSearchTreeNode({
    required super.index, 
    required super.data,
    required super.children
  });

  @override
  String toString() =>  "[$index] : $isLayerSelected ${data!.layerIndex} ${data!.layerSelectedIndex}";
  
  @override
  factory FilterSearchTreeNode.buildTree({required List<LayerFilterData> data}){
   return build(data: data.map(
    (d) => FilterSearchTreeNode(
      index: d.layerIndex,
      data: d as LayerFilterData<String>,
      children: []
    )
   ).toList());
  }

  static FilterSearchTreeNode build({required List<FilterSearchTreeNode> data}){
    FilterSearchTreeNode d = data.removeAt(0);
    if(data.isEmpty){
      return d;
    }else{
      return FilterSearchTreeNode(
        index: d.index,
        data: d.data,
        children: [build(data: data)]
      );
    }
  }

  bool get isLayerSelected => data!.layerSelectedIndex != data!.layerIndex;

  List<String> levelList({String until = ""}){
    if(until == data!.layerIndex || children.isEmpty){
      return [data!.layerIndex];
    }
    else if(isLayerSelected){
      return [data!.layerIndex, data!.layerSelectedIndex, ...(children.first as FilterSearchTreeNode).levelList(until: until)];
    }
    return [data!.layerIndex];
  }

  void toggleLevel(String value){
    if(value == data!.layerSelectedIndex){
      reset();
    }
    else{
      reset();
      data!.layerSelectedIndex = value;
    }
  }

  void reset(){
    data!.layerSelectedIndex = data!.layerIndex;
    for(var c in children){
      (c as FilterSearchTreeNode).reset();
    }
  }

  

  List<PieChartProportion> toProportionList() { 
    throw UnimplementedError();
  }
  
}