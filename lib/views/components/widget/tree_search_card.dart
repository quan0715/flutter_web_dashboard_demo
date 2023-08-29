import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:web_dashboard/models/data/filter_data_class.dart';
import 'package:web_dashboard/models/search/filter_search_node.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class TreeSearchLegend extends StatelessWidget{
  final FilterSearchTreeNode? filterTree;
  final List<Color> plate;
  final bool visible;

  const TreeSearchLegend({
    super.key,
    required this.filterTree,
    this.visible = true,
    this.plate = const <Color>[
      Colors.amber,
      Colors.red,
      Colors.blue, 
      Colors.green,
      Colors.grey,
    ],
  });

  Color getColor(int index) => plate[(index) % plate.length];
  
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
    return Visibility(
      visible: MediaQuery.of(context).size.width > 950 || visible,
      child: Row(
        children: getLabelList(filterTree as FilterSearchTreeNode, 1),
      )
    ); 
  }
}

class TreeSearchCard extends StatefulWidget{
  final List<Color> plate;
  final VoidCallback? onReset;
  final VoidCallback? onConfirm;
  final VoidCallback? onValueChange;
  final bool enableReordering;
  final Function(List<LayerFilterData<String>>)? onOrderChange;
  final String confirmLabel;
  final String resetLabel;
  final double elevation;
  final Color backgroundColor;
  final double width;
  final SearchTreeNode? searchTree; 
  final FilterSearchTreeNode? filterTree;
  const TreeSearchCard({
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
    this.enableReordering = true,
    this.onReset,
    this.onConfirm, 
    this.onValueChange,
    this.onOrderChange,
  });

  @override
  State<TreeSearchCard> createState() => _TreeSearchCardState();
}

class _TreeSearchCardState extends State<TreeSearchCard> {

  bool isReordering = false;
  Color getColor(int index) => widget.plate[(index) % widget.plate.length];
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
          // child: SearchTreeLabel(
          //   label: Text(data.index),
          //   color: getColor(level),
          //   selected: data.index == layerData.data!.layerSelectedIndex,
          //   onSelected: (bool value) => onSelected(layerData, data.index, value),
          // ),
          child: SearchTreeLabelWidget(
            label: data.index,
            color: getColor(level),
            selected: data.index == layerData.data!.layerSelectedIndex,
            onSelected: (bool value) => onSelected(layerData, data.index, value),
          ),
        ),
      ).animate().slideY(
        curve: Curves.bounceInOut,
      ),
      if((layerData).isLayerSelected && layerData.children.isNotEmpty)
        ...getAllEntries(layerData.children.first, level+1),
    ];
  }

  

  void onSelected(SearchTreeNode layerData, String index, bool value){
    setState(() {
      (layerData as FilterSearchTreeNode).toggleLevel(index);
      widget.onValueChange!();
    });
  }
  void onReorder(int oldIndex, int newIndex){
    setState(() {
      var list = widget.filterTree!.toList();
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = list.removeAt(oldIndex);
      list.insert(newIndex, item);
      widget.onOrderChange!(list);
      widget.filterTree!.reset();
    });
  }
  void onRest(){
    setState(() {
      widget.filterTree!.reset();
      widget.onValueChange!();
    });
  }
  void onClickReorderMode(){
    setState(() {
      isReordering = !isReordering;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Visibility(
                visible: isReordering,
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  buildDefaultDragHandles: false,
                  padding: EdgeInsets.zero,
                  onReorder: onReorder,
                  itemCount: widget.filterTree!.toList().length,
                  itemBuilder: (context, index){
                    // bool enabled = false;
                    return ReorderableDragStartListener(
                    key: ValueKey(index),
                    index: index,
                    // enabled: enabled,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.filterTree!.toList()[index].layerLabel, style: DashboardText.titleMedium(context)),
                          Icon(Icons.drag_indicator_rounded, color:getColor(index)), 
                        ],
                      )
                    ),
                  );
                  },
                ),
              ),
              if(!isReordering)
                ...getAllEntries(widget.filterTree!, 1), 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onRest,
                      icon: Icon(Icons.rebase_edit, color: DashboardColor.error(context),), 
                    ),
                    const SizedBox(width: 10,),
                    Visibility(
                      visible: !widget.enableReordering,
                      child: IconButton(
                        onPressed: onClickReorderMode,
                        icon: Icon(Icons.reorder_rounded, color: DashboardColor.primary(context))
                      ),
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

class SearchTreeLabelWidget extends StatelessWidget{
  final Color color;
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  const SearchTreeLabelWidget({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    this.onSelected,
  });
  @override 
  Widget build(BuildContext context) {
    // Alternative way of choice chip
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color.withOpacity(0.1)),
          side: MaterialStateProperty.all<BorderSide>(BorderSide(color: color.withOpacity(0.5),width: 1)),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 6,vertical: 3)),
        ), 
        onPressed: onSelected == null ? null : () => onSelected!(true),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(visible: selected,child: Icon(Icons.check, color: DashboardColor.onSurface(context) , size: 16,),),
            const SizedBox(width: 4,),
            Text(label, style: TextStyle(color: DashboardColor.onSurface(context)),),
          ],
        ),
      ),
    );
  }
  // SearchTreeLabel({
  //   super.key,
  //   required super.label,
  //   required this.color,
  //   required super.selected,
  //   super.onSelected,
  // }) : super(
  //   backgroundColor: color.withOpacity(0.1),
  //   selectedColor: color.withOpacity(0.1),
  //   elevation: 2,
  //   iconTheme: IconThemeData(color: color.withOpacity(0.5), size: 16),
  //   padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
  //   side: BorderSide(color: color.withOpacity(0.5),width: 1),
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),  
  // );
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
                children: List.generate(
                  dataSource.length, (index) => labelMapper(dataSource[index])
                ) 
              ),
              // child: Row(
              //   children: List.generate(
              //     dataSource.length, (index) => labelMapper(dataSource[index])
              //   ) 
              // )
            ),
          ],
        ),
      );
  }
}






