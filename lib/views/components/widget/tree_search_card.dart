import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search_node.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class TreeSearchLegend extends StatelessWidget{
  final FilterSearchTreeNode? filterTree;
  final List<Color> plate;

  const TreeSearchLegend({
    super.key,
    required this.filterTree,
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

  
  List<Widget> getLabelList(SearchTreeNode root, int level){
    return [
      if((root as FilterSearchTreeNode).isLayerSelected)
        Row(
          children: [
            SearchTreeLabel(
              label: Text(root.data!.layerSelectedIndex),
              color: getColor(level),
              selected: false,
              onSelected: (value){},
            ),
            Icon(Icons.arrow_right_rounded, color: getColor(level),)
          ],
        ),
        // .animate().fade(),
        
        if(root.children.isNotEmpty)
          ...getLabelList(root.children.first, level+1)
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: getLabelList(filterTree as FilterSearchTreeNode, 0),
    );
  }

}

class TreeSearchCard extends StatefulWidget{
  final List<Color> plate;
  final VoidCallback? onReset;
  final VoidCallback? onConfirm;
  final VoidCallback? onValueChange;
  final Function(List<LayerFilterData<String>>)? onOrderChange;
  final String confirmLabel;
  final String resetLabel;
  final double elevation;
  final Color backgroundColor;
  final double width;
  final SearchTreeNode? searchTree; 
  FilterSearchTreeNode? filterTree;
  // final List<LayerFilterData<String>> filterDataList; // pass by order
  TreeSearchCard({
    super.key, 
    required this.searchTree,
    required this.filterTree,
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
    this.onOrderChange,
  });

  @override
  State<TreeSearchCard> createState() => _TreeSearchCardState();
}

class _TreeSearchCardState extends State<TreeSearchCard> {
  Color getColor(int index) => widget.plate[(index) % widget.plate.length];

  // recursive generate filter entries
  List<Widget> getAllEntries(SearchTreeNode layerData, int level) {
    var filterList = widget.filterTree!.levelList(until: (layerData as FilterSearchTreeNode).data!.layerIndex);
    // debugPrint("${layerData.data!.layerLabel}: $layerData (level: $level, filterList: $filterList)");
    return [
      FilterEntries(
        index: layerData.data!.layerIndex,
        label: layerData.data!.layerLabel,
        color: getColor(level),  
        dataSource: (widget.searchTree!.searchTree(filterList)!).children, //..forEach((element) {element.printTree(depth: 0);}),
        labelMapper: (data) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          child: SearchTreeLabel(
            label: Text(data.index),
            color: getColor(level),
            selected: data.index == layerData.data!.layerSelectedIndex,
            onSelected: (bool value) {
              (layerData).toggleLevel(data.index);
              widget.onValueChange!();
            },
          ),
        ),
      ).animate().slideY(
        curve: Curves.bounceInOut,
      ),
      if((layerData).isLayerSelected && layerData.children.isNotEmpty)
        ...getAllEntries(layerData.children.first, level+1),
    ];
  }

  bool isReordering = false;

  @override
  Widget build(BuildContext context) {
    var allEntries = getAllEntries(widget.filterTree!, 1);
    return Card(
      color: DashboardColor.surface(context),
      elevation: widget.elevation,
      child: SizedBox(
        width: widget.width,
        child: DashboardPadding.object(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              isReordering 
              ? ReorderableListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                onReorder: (oldIndex, newIndex){
                  // debugPrint("oldIndex: $oldIndex, newIndex: $newIndex");
                  setState(() {
                    var list = widget.filterTree!.toList();
                    // debugPrint("list: ${list.map((e) => e.layerIndex)}");
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = list.removeAt(oldIndex);
                    list.insert(newIndex, item);

                    // debugPrint("list: ${list.map((e) => e.layerIndex)}");
                    widget.onOrderChange!(list);
                    widget.filterTree!.reset();
                  });
                },
                children: List.generate(
                  widget.filterTree!.toList().length, (index) => 
                    ListTile(
                      key: ValueKey(index),
                      title: FrameQuote(quoteText: "L ${index+1} ${widget.filterTree!.toList()[index].layerLabel}", color: getColor(index))
                    )
              ))
              : const SizedBox.shrink(),
              if(!isReordering)
                ...allEntries, 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: (){
                        // onReset!();
                        widget.filterTree!.reset();
                        widget.onValueChange!();
                      },
                      icon: Icon(Icons.rebase_edit, color: DashboardColor.error(context),),
                      // label: Text('清除', style:TextStyle(color: DashboardColor.error(context))),
                      
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          isReordering = !isReordering;
                        });
                      },
                      // label: Text('排序', style:TextStyle(color: DashboardColor.primary(context))),
                      icon: Icon(Icons.settings, color: DashboardColor.primary(context))
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
    // return Draggable(
    //   feedback: Material(
    //     elevation: 2,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //     type: MaterialType.card,
    //     child: Opacity(
    //       opacity: 0.8,
    //       child: body
    //     ),
    //   ),
    //   childWhenDragging:  Opacity(
    //       opacity: 0.1,
    //       child: body
    //     ),
    //   child: Row(
    //     children: [
    //       Expanded(child: body),
    //       // IconButton(
    //       //   onPressed: () {
              
    //       //   },
    //       //   icon: Icon(Icons.drag_indicator, color: color,)
    //       // ),
    //     ],
    //   ),
    // );
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

class FilterSearchTreeNode extends SearchTreeNode<LayerFilterData<String>>{
  FilterSearchTreeNode({
    required super.index, 
    required super.data,
    required super.children
  });

  @override
  String toString() =>  "[$index] : $isLayerSelected ${data!.layerIndex} ${data!.layerSelectedIndex}";
  
  @override
  factory FilterSearchTreeNode.buildTree({required List<LayerFilterData<String>> data}){
   return build(data: data.map(
    (d) => FilterSearchTreeNode(
      index: d.layerIndex,
      data: d,
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

  @override
  List<PieChartProportion> toProportionList() {
    // TODO: implement toProportionList
    throw UnimplementedError();
  }
  
}

