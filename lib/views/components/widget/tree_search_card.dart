import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search_node.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class TreeSearchLegend extends StatelessWidget{
  final TreeSearchData treeSearchData;
  final List<Color> plate;

  const TreeSearchLegend({
    super.key,
    required this.treeSearchData,
    this.plate = const <Color>[
      Colors.amber,
      Colors.red,
      Colors.blue, 
      Colors.green,
      Colors.grey,
    ], 
  });

  Color getColor(int index){
    return plate[(index) % plate.length];
  }

  
  List<Widget> getLabelList(TreeLayer root, int level){
    return [
      if(root.isLayerSelected)
        Row(
          children: [
            SearchTreeLabel(
              label: Text(root.selectedIndex),
              color: getColor(level),
              selected: false,
              onSelected: (value){},
            ),
            Icon(Icons.arrow_right_rounded, color: getColor(level),)
          ],
        ).animate().fade(),
        
        if(root.childLayer!=null)
          ...getLabelList(root.childLayer!, level+1)
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: getLabelList(treeSearchData.root, 0),
    );
  }

}

class TreeSearchCard extends StatelessWidget{
  final TreeSearchData treeSearchData;
  final List<Color> plate;
  final VoidCallback? onReset;
  final VoidCallback? onConfirm;
  final VoidCallback? onValueChange;
  final String confirmLabel;
  final String resetLabel;
  final double elevation;
  final Color backgroundColor;
  final double width;
  // final List<FilterEntries> entries;
  final SearchTreeNode? searchTree; 
  // final Widget Function(int index) labelMapper;

  const TreeSearchCard({
    super.key, 
    required this.treeSearchData,
    // required this.entries,
    required this.searchTree,
    this.plate = const <Color>[
      Colors.amber,
      Colors.red,
      Colors.blue, 
      Colors.green,
      Colors.grey,
    ], 
    this.confirmLabel = "確認",
    this.resetLabel = "重設",
    this.elevation = 5,
    this.backgroundColor = Colors.white,
    this.width = 400,
    this.onReset,
    this.onConfirm, 
    this.onValueChange,
  });

  Color getColor(int index) => plate[(index) % plate.length];
  // recursive generate filter entries
  List<Widget> getAllEntries(TreeLayer layer, int level) {
    var filterList = treeSearchData.root.levelList(until: layer) as List<String>;
    return [
      FilterEntries(
        index: layer.layerIndex,
        label: layer.layerLabel,
        color: getColor(level),  
        dataSource: (searchTree!.searchTree(filterList)!).children,
        labelMapper: (data) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          child: SearchTreeLabel(
            label: Text(data.index),
            color: getColor(level),
            selected: layer.selectedIndex == data.index,
            onSelected: (bool value) {
              layer.toggleLevel(data.index);
              onValueChange!();
            },
          ),
        ),
      ).animate().slideY(
        curve: Curves.bounceInOut,
      ),
      if(layer.isLayerSelected && layer.childLayer != null)
        ...getAllEntries(layer.childLayer!, level+1),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DashboardColor.surface(context),
      elevation: elevation,
      child: SizedBox(
        width: width,
        child: DashboardPadding.object(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...getAllEntries(treeSearchData.root, 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: (){
                          onReset!();
                          onValueChange!();
                        },
                        child: Text(resetLabel),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        child: Text(confirmLabel),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY();
  }
}

class SearchTreeLabel extends ChoiceChip{
  final Color color;
  SearchTreeLabel({
    super.key,
    required super.label,
    required this.color,
    required super.selected,
    super.onSelected,
  }) : super(
    backgroundColor: color.withOpacity(0.1),
    selectedColor: color.withOpacity(0.1),
    elevation: 2,
    iconTheme: IconThemeData(color: color.withOpacity(0.5), size: 16),
    padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
    side: BorderSide(color: color.withOpacity(0.5),width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),  
  );
}

class FilterEntries<DataSourceType> extends StatelessWidget{
  final String label;
  final Color color;
  final String index;
  // final int level;
  final List<DataSourceType> dataSource;
  final Widget Function(DataSourceType) labelMapper;
  // final bool isVisible; 

  const FilterEntries({
    super.key,
    required this.label,
    // required this.isVisible, 
    this.color = Colors.grey, 
    required this.index,
    // required this.level,
    required this.dataSource,
    required this.labelMapper,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FrameQuote(quoteText: label, color: color,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              children: dataSource.map<Widget>(labelMapper).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class LayerFilterData<T>{
  T layerLabel;
  T layerSelectedIndex;
  T layerIndex;
  List<T> indexes;
  // Function<bool>(dynamic,dynamic) layerSelectedValidator;
  LayerFilterData({
    required this.layerLabel,
    required this.layerSelectedIndex,
    required this.layerIndex,
    this.indexes = const [],
    // required this.layerSelectedValidator,
  });
}

class SearchTreeLayer extends SearchTreeNode<LayerFilterData<String>>{
  SearchTreeLayer({
    required super.index, 
    required super.data,
    required super.children
  });

  @override
  String toString() =>  "[$index] : $isLayerSelected";
  
  @override
  factory SearchTreeLayer.buildTree({required List<LayerFilterData<String>> data}){
   return build(data: data.map(
    (d) => SearchTreeLayer(
      index: d.layerIndex,
      data: d,
      children: []
    )
   ).toList());
  }

  static SearchTreeLayer build({required List<SearchTreeLayer> data}){
    SearchTreeLayer d = data.removeAt(0);
    if(data.isEmpty){
      return d;
    }else{
      return SearchTreeLayer(
        index: d.index,
        data: d.data,
        children: [build(data: data)]
      );
    }
  }

  bool get isLayerSelected => data!.layerSelectedIndex != data!.layerIndex;

  List<String> levelList(){
    // 往上面找東西
    // if(until!=null && until == this){
    //   return [layerIndex];
    // }
    if(!isLayerSelected || children.isEmpty){
      return [index];
    }

    return [index, ...(children.first as SearchTreeLayer).levelList()];
  }

  @override
  List<PieChartProportion> toProportionList() {
    // TODO: implement toProportionList
    throw UnimplementedError();
  }
  
}

class TreeLayer<T>{
  T layerLabel;
  T layerIndex;
  late T selectedIndex;
  TreeLayer<T>? childLayer;
  TreeLayer({
    required this.layerLabel,
    required this.layerIndex,
    this.childLayer,
  }){
    selectedIndex = layerIndex;
  }
  bool get isLayerSelected => 
    selectedIndex != layerIndex;
  
  void toggleLevel(T value){
    if(value == selectedIndex){
      reset();
    }
    else{
      reset();
      selectedIndex = value;
    }
  }

  void reset(){
    selectedIndex = layerIndex;
    childLayer?.reset();
  }

  List<T> levelList({TreeLayer? until}){
    // 往上面找東西
    if(until!=null && until == this){
      return [layerIndex];
    }
    if(!isLayerSelected || childLayer == null){
      return [selectedIndex];
    }

    return [selectedIndex, ...childLayer!.levelList(until: until)];
  }
  
  TreeLayer<T>? search(T index){
    if(layerIndex == index){
      return this;
    }
    if(childLayer == null){
      return null;
    }
    return childLayer!.search(index);
  }

  List<T> indexOrderList(){
    if(childLayer == null){
      return [layerIndex];
    }
    return [layerIndex,  ...childLayer!.indexOrderList()];
  }
}

class TreeSearchData<T>{
  final TreeLayer<T> root;

  TreeSearchData({
    required this.root,
  });

  List<T> get getSearchList => root.levelList();

  List<T> get getSearchIndexOrderList => root.indexOrderList();

}
