import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/db/db_config.dart';
import 'package:web_dashboard/models/group_consumption_data_model.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';
import 'package:web_dashboard/views/components/widget/tree_search_card.dart';
import 'package:web_dashboard/views/theme/theme.dart';
import 'package:web_dashboard/view_model/dashboard/electricity_consumption_view_model.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';

class DashboardSearchBar extends StatefulWidget {
  const DashboardSearchBar({super.key});

  @override
  State<DashboardSearchBar> createState() => _DashboardSearchBarState();
}

class _DashboardSearchBarState extends State<DashboardSearchBar> {

  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey levelFilterButtonKey = GlobalKey();  

  Widget choiceChipBuilder(String label, Color color, selected, onSelected){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        elevation: 2,
        selectedColor: color.withOpacity(0.1),
        iconTheme: IconThemeData(color: color.withOpacity(0.5), size: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2
        ),
        side: BorderSide(
            color: color.withOpacity(0.5),
            width: 1
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
          ),
        backgroundColor: color.withOpacity(0.1),
        
        label: Text(label),
        selected: selected,
        onSelected: onSelected
      ),
    );
  }


  Widget levelFilter(){
    return Consumer<ElectricityConsumptionDashboardViewModel>(
      builder: (context, viewModel, child) {
      return Row(
        children: [
          MaterialButton(
            key: levelFilterButtonKey,
            onPressed: ()async {
              final buttonPosition = levelFilterButtonKey.currentContext!.findRenderObject() as RenderBox;
              var temp = TreeSearchData(root: viewModel.treeSearchData.root);
              var result = await showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) => ChangeNotifierProvider<ElectricityConsumptionDashboardViewModel>.value(
                  value: viewModel,
                  child: Consumer<ElectricityConsumptionDashboardViewModel>(
                    builder: (context, viewModel, child) => 
                      Stack(
                        children: [
                          Positioned(
                            top: buttonPosition.size.height + buttonPosition.localToGlobal(Offset.zero).dy + 5,
                            left: buttonPosition.localToGlobal(Offset.zero).dx,
                            child: TreeSearchCard(
                              searchTree: viewModel.getTodayConsumptionDataSearchTree!,
                              treeSearchData: viewModel.treeSearchData,
                              plate: const InstagramGrad().colors,
                              onConfirm: () => Navigator.pop(context, true), 
                              onReset: () => viewModel.treeSearchData.root.reset(),
                              onValueChange: viewModel.refreshPage,
                            ),
                          )
                        ],
                      ),
                  ),
                )
                );
            }, 
            child: RawChip(
              side: BorderSide.none,
              avatar: Icon(Icons.filter_list, color: DashboardColor.primary(context)),
              label: const Text("LEVEL: 階層篩選")),
          ),
          TreeSearchLegend(
            treeSearchData: viewModel.treeSearchData,
            plate: const InstagramGrad().colors,
          )
        ],
      );
      }
    );
  }

  Widget groupTypeFilter(viewModel){
    return DropdownButton<String>(
      // drop sown menu for group type
      padding: EdgeInsets.zero,
      elevation: 0,
      style: DashboardText.titleMedium(context),
      underline: Container(),
      items : viewModel.groupType.map<DropdownMenuItem<String>>(
        (label) => DropdownMenuItem(
          value: label,
          child: RawChip(
            side: BorderSide.none,
            avatar: Icon(Icons.filter_list, color: DashboardColor.primary(context)),
            label: Text("GROUP: $label")
          )
        ),
      ).toList(),
      onChanged: (value) => viewModel.setGroupType = value!,
      value: viewModel.targetGroupType
    );
  }

  Widget dateTimeFilter(viewModel){
    return MaterialButton(
      key: _buttonKey,
      onPressed: ()async{
        final buttonPosition = _buttonKey.currentContext!.findRenderObject() as RenderBox;
        final result = await showDatePicker(context: context, 
          initialDate: viewModel.targetDateTime,
          firstDate: viewModel.targetDateTime.subtract(const Duration(days: 365)), 
          lastDate: DateTime.now(),
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          helpText: "選擇觀測區間",
          cancelText: "取消",
          confirmText: "確認",
          builder: (context, child) {
            return Stack(
              children: [
                // Positioned.fill(child: Container(color: Colors.amber.withOpacity(0.01),)),
                Positioned(
                  top: buttonPosition.size.height + buttonPosition.localToGlobal(Offset.zero).dy + 10,
                  left: buttonPosition.localToGlobal(Offset.zero).dx,
                  child: child!,
                )
              ],
            );
          },
        );
        // 
        if(result != null){
          viewModel.setTargetDateTime = result;
          debugPrint(viewModel.targetDateTime.toString());
          // debugPrint(viewModel.targetDateTime.day == DateTime.now().day ? "今天" : DashBoardFormat.time(viewModel.targetDateTime));
        }
      },
      child:RawChip(
        side: BorderSide.none,
        avatar: Icon(Icons.filter_list, color: DashboardColor.primary(context)),
        label: Text("時間: ${DashBoardFormat.timePickerLabel(viewModel.targetDateTime)}")
      )
    );
  }

  Widget verticalDivider()
      => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: VerticalDivider(width: 15, color: DashboardColor.surfaceVariant(context), thickness: 3, indent: 5,endIndent: 5,),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<ElectricityConsumptionDashboardViewModel>(
      builder: (context, viewModel,child)=> SizedBox(
        height: 70,
        child: DashboardFrameCard(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          elevation: 3,
          child: Row(
            children: [
              // DropdownButton<String>(
              //   // drop sown menu for group type
              //   padding: EdgeInsets.zero,
              //   elevation: 0,
              //   style: DashboardText.titleMedium(context),
              //   underline: Container(),
              //   items : viewModel.groupType.map<DropdownMenuItem<String>>(
              //     (label) => DropdownMenuItem(
              //       value: label,
              //       child: RawChip(
              //         side: BorderSide.none,
              //         avatar: Icon(Icons.filter_list, color: DashboardColor.primary(context)),
              //         label: Text("GROUP: $label")
              //       )
              //     ),
              //   ).toList(),
              //   onChanged: (value) => viewModel.setGroupType = value!,
              //   value: viewModel.targetGroupType
              // ),
              // verticalDivider(),
              dateTimeFilter(viewModel),
              verticalDivider(),
              levelFilter(),
              verticalDivider(),
              const Spacer(),
              verticalDivider(),
              
              // ChoiceChip(
              //   iconTheme: IconThemeData(color: DashboardColor.onError(context), size: 32),
              //   backgroundColor: DashboardColor.surface(context),
              //   label: viewModel.isShowErrorOnly ? const Text("只顯示異常") : const Text("顯示全部"),
              //   selected: viewModel.isShowErrorOnly,
              //   selectedColor: DashboardColor.error(context).withOpacity(0.1),
              //   side: 
              //     viewModel.isShowErrorOnly
              //       ? BorderSide(color: DashboardColor.error(context).withOpacity(0.5), width: 1)
              //       : BorderSide.none,
              //   onSelected: (value) => viewModel.setIsShowAll = value,
              // ),
              // verticalDivider(),
              Switch(
                thumbIcon: MaterialStateProperty.all(
                  viewModel.isDashboardView
                    ? Icon(Icons.dashboard, color: DashboardColor.primary(context))
                    : const Icon(Icons.table_chart, color: Colors.white)
                ),
                activeColor: DashboardColor.primary(context).withOpacity(0.1),
                inactiveThumbColor: Colors.amber,
                value: viewModel.isDashboardView, 
                onChanged: (value) => viewModel.setIsDashboard = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

