import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/models/search/consumption_search_node.dart';
import 'package:web_dashboard/models/search/filter_search_node.dart';
import 'package:web_dashboard/view_model/dashboard/consumption_report_dashboard_view_model.dart';
import 'package:web_dashboard/views/components/chart/monthly_report_line_chart.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/widget/dashboard_search_bar.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';
import 'package:web_dashboard/views/components/widget/tree_search_card.dart';

import '../../theme/theme.dart';

class ConsumptionReportDashboardView extends StatefulWidget {
  const ConsumptionReportDashboardView({Key? key}) : super(key: key);

  @override
  State<ConsumptionReportDashboardView> createState() => _ConsumptionReportDashboardViewState();
}

class _ConsumptionReportDashboardViewState extends State<ConsumptionReportDashboardView> {
  

  ConsumptionReportDashboardViewModel viewModel = ConsumptionReportDashboardViewModel(); 

  // Future init() async {
  //   await viewModel.init();
  // }

  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  Widget loadingView(){
    return const Center(
      child: CircularProgressIndicator(),
    ).animate();
  }

  Widget numberDisplayFrame(){
    return DashboardFrameCard(
      elevation: 0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardFrameCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("2023 July. G1 M10", style: DashboardText.headLineMedium(context).copyWith(
                    color: Colors.amber,
                  )),
                  Text("2023.07.01 ~ 2023.07.31", style: DashboardText.titleMedium(context).copyWith(
                    color: DashboardColor.secondary(context),
                  )),
                ],
              )
            ),
            const SizedBox(height: 5, width: 5,),
            GridView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1.3,
              ),
              children:[
                DashboardDataCard(
                  label: "月累積電費",
                  value: DashBoardFormat.number(214786),
                  unit: "單位 萬",
                ),
                DashboardDataCard(
                  label: "電費漲幅",
                  value: "-13 %",
                  unit: "2022 Aug",
                  valueColor: DashboardColor.correct,
                ),
                DashboardDataCard(
                  label: "月累積耗電量",
                  value: DashBoardFormat.number(517224),
                  unit: "Kwh",
                ),
                DashboardDataCard(
                  label: "用電量漲幅",
                  value: "+20 %",
                  unit: "2022 Aug",
                  valueColor: DashboardColor.error(context),
                ),
                const DashboardDataCard(
                  label: "月小時平均耗電量",
                  value: "768",
                  unit: "Kwh / hour",
                ),
                DashboardDataCard(
                  label: "月小時平均耗電量",
                  value: "+24 %",
                  unit: "2022 Aug",
                  valueColor: DashboardColor.error(context),
                ),
                DashboardDataCard(
                  label: "月累積錯誤回報",
                  value: "9",
                  
                  valueColor: DashboardColor.error(context),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Widget timeLineFrame(){
    return DashboardFrameCard(
      elevation: 0,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: MonthlyReportLineChart<ConsumptionSearchNode>(
              data: viewModel.monthReport,
              cmpLine: viewModel.lastYearMonthReport,
              xValueMapper: (data, index) => DashBoardFormat.iO8dateTime((data).dateTime.toIso8601String()),
              yValueMapper: (data, _) => data.dayConsumption,
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }

  Widget normalScreenSizeView(BoxConstraints constraints){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: numberDisplayFrame(),
        ),
        Expanded(
          flex: 3,
          child: timeLineFrame()
        ), 
    ],);
  }
  
  Widget mediumScreenSizeView(BoxConstraints constraints){
    return Center(
      child: Text("layout not support", style: DashboardText.labelLarge(context)),
    );

  }

  Widget smallScreenSizeView(BoxConstraints constraints){
    return Center(
      child: Text("layout not support", style: DashboardText.labelLarge(context)),
    );
  }

  Widget noneSupportScreenSizeView(){
    return Center(
      child: Text("layout not support", style: DashboardText.labelLarge(context)),
    );
  }

  Widget noneDataDialogView(){
    return Center(
      child: Text("no data", style: DashboardText.labelLarge(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConsumptionReportDashboardViewModel>.value(
      value: viewModel,
      child: Consumer<ConsumptionReportDashboardViewModel>(
        builder: (context, viewModel, child) =>
        Scaffold(
          appBar: const DashboardAppBar(title: "用電量 ESG 報告"),
          drawer: const DashboardDrawer(),
          body: DashboardPadding.small(
            child: SizedBox.expand(
                child: DashboardPadding.small(
                  child: Column(
                    children: [
                      viewModel.loadingState == LoadingState.loading
                      ? const SizedBox.shrink()
                      : DashboardSearchBar(
                        children: [
                          LevelFilterList(
                            treeSearchCard: TreeSearchCard(
                              searchTree: viewModel.searchTree!,
                              // filterTree: viewModel.filterSearchTreeNode as FilterSearchTreeNode,
                              filterOrder: viewModel.filterOrder,
                              // plate: const InstagramGrad().colors,
                              enableReordering: false,
                              onValueChange: viewModel.refreshPage,
                            ),
                            treeSearchLegend: TreeSearchLegend(
                              filterTree: viewModel.filterSearchTreeNode as FilterSearchTreeNode,
                              // plate: const InstagramGrad().colors,
                            ),
                        )],
                      ),
                      Expanded(
                        child: DashboardFrameCard(
                          elevation: 3,
                          child: viewModel.loadingState == LoadingState.loading
                          ? loadingView()
                          // : viewModel.sumOfElectricityConsumptionDataList.isEmpty
                            // ? noneDataDialogView()
                          : LayoutBuilder(
                            builder: (context, constraints){
                              ResponsiveLayoutType layoutType = DashboardLayout.getLayout(constraints); 
                              return switch (layoutType) {
                                ResponsiveLayoutType.big => normalScreenSizeView(constraints),
                                ResponsiveLayoutType.medium => mediumScreenSizeView(constraints),
                                ResponsiveLayoutType.small => smallScreenSizeView(constraints),
                                ResponsiveLayoutType.none => noneSupportScreenSizeView()
                              };
                            }
                          )
                        )
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class DashboardDataCard extends StatelessWidget{
  const DashboardDataCard({
    super.key,
    required this.value,
    this.label,
    this.unit,
    this.unitColor,
    this.labelColor,
    this.valueColor,
  });
  final String? label;
  final String value;
  final String? unit;
  final Color? labelColor;
  final Color? valueColor;
  final Color? unitColor;
  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = DashboardText.titleMedium(context).copyWith(
      color: labelColor != null ? labelColor! : DashboardColor.secondary(context)
    );
    TextStyle valueStyle = DashboardText.titleMedium(context).copyWith(
      color: valueColor != null ? valueColor! : DashboardColor.primary(context)
    );
    TextStyle unitStyle = DashboardText.titleMedium(context).copyWith(
      color: unitColor != null ? unitColor! : DashboardColor.secondary(context)
    );
    const space = SizedBox(height: 5,);

    return DashboardFrameCard(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          label != null ? Text(label!, style: labelStyle) : const SizedBox.shrink(),
          space,
          Text(value, style: valueStyle),
          space, 
          unit!=null ? Text(unit!, style: unitStyle) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}


class LevelFilterList extends StatelessWidget{
  LevelFilterList({
    super.key,
    required this.treeSearchCard,
    this.treeSearchLegend,
    this.title = "篩選條件",
  });
  final Widget treeSearchCard;
  final Widget? treeSearchLegend;
  final String title;
  final GlobalKey buttonKey = GlobalKey();

  Widget get card => treeSearchCard;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          MaterialButton(
            key: buttonKey,
            onPressed: ()async {
              final buttonPosition = buttonKey.currentContext!.findRenderObject() as RenderBox;
              await showDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: title,
                builder: (BuildContext context) => 
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return constraints.maxWidth > 600
                        ? Stack(
                          children: [
                            Positioned(
                              top: buttonPosition.size.height + buttonPosition.localToGlobal(Offset.zero).dy + 1,
                              left: buttonPosition.localToGlobal(Offset.zero).dx,
                              child: card 
                            )
                          ],
                        )
                        : Center(child: card);
                    }
                  )
                );
            }, 
            child: RawChip(
              side: BorderSide.none,
              avatar: Icon(Icons.filter_list, color: DashboardColor.primary(context)),
              label: Text(title)),
          ),
          if (treeSearchLegend != null)
            treeSearchLegend!,
        ],
      );
  }
}

