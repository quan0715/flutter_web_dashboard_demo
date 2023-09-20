import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search/consumption_search_node.dart';
import 'package:web_dashboard/models/search/filter_search_node.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/views/components/chart/dashboard_info_card.dart';
import 'package:web_dashboard/views/components/chart/dashboard_data_card.dart';
import 'package:web_dashboard/views/components/chart/dashboard_pie_chart.dart';
import 'package:web_dashboard/views/components/chart/weakly_consumption_line_chart.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/data_grid.dart';
import 'package:web_dashboard/view_model/dashboard/electricity_consumption_view_model.dart';
import 'package:web_dashboard/views/components/data/sum_consumption_table.dart/data_grid.dart';
import 'package:web_dashboard/views/components/widget/dashboard_page.dart';
import 'package:web_dashboard/views/components/widget/dashboard_widget.dart';
import 'package:web_dashboard/views/pages/dashboard/consumption_report_dashboard_view.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class ConsumptionMonitorDashboardView extends StatefulWidget {
  const ConsumptionMonitorDashboardView({Key? key}) : super(key: key);

  @override
  State<ConsumptionMonitorDashboardView> createState() => _ConsumptionMonitorDashboardViewState();
}

class _ConsumptionMonitorDashboardViewState extends State<ConsumptionMonitorDashboardView> with DashboardPageTemplate{
  late final viewModel = ElectricityConsumptionDashboardViewModel();

  Future<void> init() async => await viewModel.init();
  
  @override
  initState(){
    super.initState();
    init();
  }
  
  Widget priceSwitcher(){
    return Switch(
      thumbIcon: MaterialStateProperty.all(
        viewModel.isShowConsumptionData
          ? const Icon(Icons.electric_meter)
          : const Icon(Icons.money, )
      ),
      inactiveThumbColor: Colors.green,
      value: viewModel.isShowConsumptionData, 
      onChanged: (value) => viewModel.setIsDashboard = value,
    );
  }
  
  Widget errorReportTableView(){
    return DashboardFrameCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FrameQuote(
            quoteText: viewModel.isShowConsumptionData ? "異常回報清單" : "近7天電費累積數據表",
            color: viewModel.isShowConsumptionData ? DashboardColor.primary(context) : Colors.green,
          ),
          Expanded(child: SingleChildScrollView(
            child: viewModel.isShowConsumptionData 
            ? DeviceErrorReportTableDataGrid.smallView(
              dataSource: viewModel.deviceErrorReportList,
            ) : SumOfElectricityConsumptionDataGrid(
              dataSource: viewModel.sortedByBillSumOfElectricityConsumptionDataList,
              priceOnly: true,
            )
          ))
        ],
      ),
    );
  }

  Widget consumptionTimelineChartFrame(){
    return DashboardFrameCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FrameQuote(
            quoteText: "用電量時間軸圖", 
            color: viewModel.isShowConsumptionData ? DashboardColor.primary(context) : Colors.green
          ),
          Expanded( 
            child: DashboardTimeLineChart(
              data: viewModel.weeklySumOfElectricityConsumptionDataList,
              xValueMapper: (data, index) => DashBoardFormat.iO8dateTime((data as ConsumptionSearchNode).dateTime.toIso8601String()) ,
              yValueMapper: (data, index) => 
                viewModel.isShowConsumptionData 
                ? (data as ConsumptionSearchNode).dayConsumption
                : (data as ConsumptionSearchNode).billPrice,
              cmpLine: viewModel.lastWeekSumOfElectricityConsumptionDataList,
              numericAxisLabel: viewModel.isShowConsumptionData ? "用電量" : "電費",
              mainLineLabel: viewModel.isShowConsumptionData ? "近7天用電量趨勢" : "近7天電費數據",
              mainLineColor: viewModel.isShowConsumptionData ? DashboardColor.primary(context) : Colors.green,
              comparedLineLabel: viewModel.isShowConsumptionData ? "上7天週期用電量趨勢" : "上7天週期用電費趨勢",
              chartNumericUnit: viewModel.isShowConsumptionData ? "kWh" : "NTD",
            )
          ),
        ],
      ),
    );
  }

  Widget groupDetailDataFrame(){
    List<SearchTreeNode> source = viewModel.getOverAllData!.children;
    return DashboardFrameCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FrameQuote(
            color: viewModel.isShowConsumptionData ? DashboardColor.primary(context) : Colors.green,
            quoteText: viewModel.isShowConsumptionData ? "各監測點用電量詳細數據" : "各監測點電費詳細數據", 
            // notes:  viewModel.isShowConsumptionData ? "單位 KWH" : "單位 NTD",
          ),
          Expanded(
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, childAspectRatio: 2, mainAxisSpacing: 6, crossAxisSpacing: 8,
              ),
              itemCount: source.length,
              itemBuilder: (context, index) {
                return ConsumptionDetailGridView(
                  label: source[index].index,
                  color: viewModel.isShowConsumptionData ? DashboardColor.secondary(context) : Colors.green,
                  valueBlocks: viewModel.isShowConsumptionData ? [
                    ValueBlock(blockTitle: "日累積用電", blockUnit: "kWh", blockValue: (source[index] as ConsumptionSearchNode).dayConsumption),
                    ValueBlock(blockTitle: "月累積用電", blockUnit: "kWh", blockValue: (source[index] as ConsumptionSearchNode).monthConsumption),
                    ValueBlock(blockTitle: "月平均小時用電", blockUnit: "kWh", blockValue: (source[index] as ConsumptionSearchNode).averageMonthConsumptionPerMonth.round())
                  ] : [
                    ValueBlock(blockTitle: "日累積用電", blockUnit: "kWh", blockValue: (source[index] as ConsumptionSearchNode).dayConsumption),
                    ValueBlock(blockTitle: "日累積電費", blockUnit: "NTD", blockValue: (source[index] as ConsumptionSearchNode).billPrice.round()),
                    ValueBlock(blockTitle: "每度電平均電費", blockUnit: "NTD", blockValue: (source[index] as ConsumptionSearchNode).averageBillPerUnit.round()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget overViewFrame(){
    var dataSource = viewModel.getOverAllData!;
    final data = viewModel.isShowConsumptionData ? 
    [{
        "title" : "日累積總用電量",
        "value" : dataSource.dayConsumption,
        "unit" : "kWh", 
      },{
        "title" : "累積總月用電量",
        "value" : dataSource.monthConsumption,
        "unit" : "kWh", 
      },{
        "title" : "每小時平均用電量",
        "value" : dataSource.averageMonthConsumptionPerMonth.toInt(),
        "unit" : "kWh", 
      },
      
    ] : [
      {
        "title" : "日累積總用電量",
        "value" : dataSource.dayConsumption,
        "unit" : "kWh", 
      },
      {
        "title" : "今日累績電費",
        "value" : dataSource.billPrice.toInt(),
        "unit" : "NTD", 
      },
      {
        "title" : "每度電平均電費",
        "value" : dataSource.averageBillPerUnit.toInt(),
        "unit" : "NTD", 
      }
    ];
    return DashboardFrameCard(
      elevation: 0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FrameQuote(
              color: viewModel.isShowConsumptionData ? DashboardColor.primary(context) : Colors.green,
              quoteText: viewModel.isShowConsumptionData ? "用電量分佈" : "電費產生分佈圖",
            ),
            viewModel.isShowConsumptionData 
            ? DashboardPieChart(
              chartTitle: "總累積電量",
              chartAmountUnitLabel: "kWh",
              dataSource: PieChartProportion.listBuilder<ConsumptionSearchNode>(
                dataSource: (viewModel.getOverAllData?.children as List<ConsumptionSearchNode>),
                indexBuilder: (node) => node.index,
                valueBuilder: (node) => node.dayConsumption,
              ),
            )
            : DashboardPieChart(
              chartTitle: "總累積電費",
              chartAmountUnitLabel: "NTD",
              dataSource: PieChartProportion.listBuilder<ConsumptionSearchNode>(
                dataSource: (viewModel.getOverAllData?.children as List<ConsumptionSearchNode>),
                indexBuilder: (node) => node.index,
                valueBuilder: (node) => node.billPrice,
              ),
            ),
            Column(
              children: data.map<Widget>(
                (d) => InfoCard(
                  title: d["title"] as String,
                  value: d["value"] as int,
                  unit: d["unit"] as String,
                )
              ).toList()
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget normalScreenSizeView(){
    return Row( 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 1, child: overViewFrame()),
          Expanded(flex: 1, child: groupDetailDataFrame()),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 3, child: consumptionTimelineChartFrame()),
                Expanded(flex: 2, child: errorReportTableView()),
              ],
            ),
          )]
        );
  }

  @override
  Widget mediumScreenSizeView(){
    return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Row( children: [
                      Expanded(flex: 1, child: overViewFrame()),
                      Expanded(flex: 1, child: groupDetailDataFrame()),
                      ]
                    ),
                ),
                Expanded(
                  flex: 6,
                  child: PageView(
                    children: [
                      consumptionTimelineChartFrame(),
                      errorReportTableView()
                    ]
                    ),
                ),
              ],
            ),
          ),
        );

  }

  @override
  Widget smallScreenSizeView(){
    return Column(
        children: [
          Expanded(
            flex: 6, child: PageView(
              children: [ overViewFrame(), groupDetailDataFrame()],
            ),
          ),
          Expanded(
            flex: 7,
            child: PageView(
              children: [ consumptionTimelineChartFrame(), errorReportTableView()],
            ),
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ElectricityConsumptionDashboardViewModel>.value(
      value: viewModel,
      child: Consumer<ElectricityConsumptionDashboardViewModel>(
        builder: (context, viewModel, child) => DashboardPage(
          pageTitle: viewModel.isShowConsumptionData ? "每日累積報告 - 電量" : "每日累積報告 - 電價",
          isSearchBarVisible: true,
          searchBar: viewModel.loadingState == LoadingState.free
          ? DashboardSearchBar(
            children: [
              DateFilterList(), 
              LevelFilterList(
                treeSearchCard: TreeSearchCard(
                  searchTree: viewModel.getTodayData,
                  // filterTree: viewModel.filterSearchTreeNode as FilterSearchTreeNode,
                  filterOrder: viewModel.filterOrder,
                  // plate: const InstagramGrad().colors,
                  enableReordering: true,
                  onValueChange: viewModel.refreshPage,
                  onFilterOrderChange: (value) => viewModel.setFilterOrder = value,
                ),
                treeSearchLegend: TreeSearchLegend(
                  filterTree: viewModel.filterSearchTreeNode as FilterSearchTreeNode,
                  // plate: const InstagramGrad().colors,
                ),
              ), const Spacer(), priceSwitcher(),            
            ]              
          ) : const SizedBox.shrink(),
          body: viewModel.loadingState == LoadingState.free
          ? viewModel.loadingState == LoadingState.loading
          ? loadingView()
          : viewModel.sumOfElectricityConsumptionDataList.isEmpty || viewModel.getOverAllData == null
            ? noneDataDialogView()
            : LayoutBuilder(
              builder: (context, constraints){
                ResponsiveLayoutType layoutType = DashboardLayout.getLayout(constraints); 
                return switch (layoutType) {
                  ResponsiveLayoutType.big => normalScreenSizeView(),
                  ResponsiveLayoutType.medium => mediumScreenSizeView(),
                  ResponsiveLayoutType.small => smallScreenSizeView(),
                  ResponsiveLayoutType.none => noneSupportScreenSizeView(),
                };
              }
            ) : loadingView()
          ),
        ),
      );
  }
}


class DateFilterList extends StatelessWidget{
  DateFilterList({super.key});

  final GlobalKey buttonKey = GlobalKey();

  final String title = "Level: 階層篩選";

  @override
  Widget build(BuildContext context) {
    return Consumer<ElectricityConsumptionDashboardViewModel>(
      builder: (context, viewModel, child) => MaterialButton(
        key: buttonKey,
        onPressed: ()async{
          final buttonPosition = buttonKey.currentContext!.findRenderObject() as RenderBox;
          final DateTime? result = await showDialog(
            context: context, 
            barrierDismissible: true,
            barrierLabel: "時間篩選",
            // barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return LayoutBuilder(
                builder: (context, constrain) {
                  Widget datePicker = DatePickerDialog(
                      initialDate: viewModel.targetDateTime,
                      firstDate: viewModel.targetDateTime.subtract(const Duration(days: 365)), 
                      lastDate: DateTime.now(),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      helpText: "選擇觀測區間",
                      cancelText: "取消",
                      confirmText: "確認",
                  );
                  if(constrain.maxWidth > 600){
                    return Stack(
                      children: [
                        Positioned(
                          top: buttonPosition.size.height + buttonPosition.localToGlobal(Offset.zero).dy - 15,
                          left: buttonPosition.localToGlobal(Offset.zero).dx - 20,
                          child: datePicker,
                        ),
                      ],
                    );
                  }else{
                    return datePicker;
                  }
                }
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
      ),
    );
  }
}
