import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';

/// ## Search Tree Node
/// abstract class SearchTreeNode<T> is a tree node for search tree
/// it contains a index and a list of child leaf
/// * \<T\> is the type of data stored in the leaf node
/// * index:the index of the node, typically a string which represents a category of the data. the search tree will base on this index to search the data
/// * children: the list of child leaf
/// * data: the data stored in the leaf node, the data will be storage in two use cases:
///       1. normally the node is a leaf node, the data will be the data of the leaf node
///       2. If the date need to be accumulated, the node will be a non-leaf node, the data will be the accumulated data of the leaf node. 
///          in this use case if the node is not a leaf node, the data will be null
/// 
/// example: if we have a data list like this:
/// 
/// [SearchTreeNode.buildTree] will build a search tree base on the data list and grouping index order
/// | Name | Age | Gender | School |
/// | :-----:| :----: | :----: | :----: |
/// | Quan | 18 | Male | NCU | 
/// | Henry | 18 | Male | NCKU |
/// | Kelly | 19 | Female | NCU |
/// | Benson | 21 | Male | NTU |
/// | Betty | 21 | Female | NCCU |
/// I want to group Gender > Age > School > Name, the search tree will be like this:
     
class SearchTreeNode<T>{

  String index;
  T? data;
  List<SearchTreeNode<T>> children = [];
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
    SearchTreeNode node = _searchTree(target)!;
    if(indexes.length == 1){
      return node;
    }else{
      indexes.removeAt(0);
      return node.searchTree(indexes);
    }
  }

  SearchTreeNode? _searchTree(String index){
    if(this.index == index){
      return this;
    }else{
      for(SearchTreeNode node in children){
        var r = node._searchTree(index);
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

  List<PieChartProportion> toProportionList()=>
    throw UnimplementedError();
  @override
  String toString() => "[$index]";

  
}
