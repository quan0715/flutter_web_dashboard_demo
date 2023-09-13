import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/search/consumption_search_node.dart';
import 'package:web_dashboard/models/search/filter_search_node.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/views/components/chart/info_card.dart';
import 'package:web_dashboard/views/components/chart/sum_consumption_detail_grid_view.dart';
import 'package:web_dashboard/views/components/chart/sum_consumption_pie_chart.dart';
import 'package:web_dashboard/views/components/chart/weakly_consumption_line_chart.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/data_grid.dart';
import 'package:web_dashboard/view_model/dashboard/electricity_consumption_view_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_grid.dart';
import 'package:web_dashboard/views/components/data/sum_consumption_table.dart/data_grid.dart';
import 'package:web_dashboard/views/components/widget/dashboard_widget.dart';
import 'package:web_dashboard/views/pages/dashboard/consumption_report_dashboard_view.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class ConsumptionMonitorDashboardView extends StatefulWidget {
  const ConsumptionMonitorDashboardView({Key? key}) : super(key: key);

  @override
  State<ConsumptionMonitorDashboardView> createState() => _ConsumptionMonitorDashboardViewState();
}

class _ConsumptionMonitorDashboardViewState extends State<ConsumptionMonitorDashboardView> with SingleTickerProviderStateMixin{
  late final TabController tabController;
  late final viewModel = ElectricityConsumptionDashboardViewModel();

  Future<void> init() async {
    await viewModel.init();
  }

  @override
  initState(){
    super.initState();
    init();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  dispose(){
    tabController.dispose();
    super.dispose();
  }
  
  Widget tableSwitcher(){
    return Switch(
      thumbIcon: MaterialStateProperty.all(
        viewModel.isDashboardView
          ? Icon(Icons.dashboard, color: DashboardColor.primary(context))
          : const Icon(Icons.table_chart, color: Colors.white)
      ),
      activeColor: DashboardColor.primary(context).withOpacity(0.1),
      inactiveThumbColor: Colors.amber,
      value: viewModel.isDashboardView, 
      onChanged: (value) => viewModel.setIsDashboard = value,
    );
  }
  
  Widget errorReportTableView(){
    return DashboardFrameCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FrameQuote(
            quoteText: "異常回報清單（篩）",
          ),
          Expanded(child: SingleChildScrollView(
            child: DeviceErrorReportTableDataGrid.smallView(
              dataSource: viewModel.deviceErrorReportList,
            ),
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
          const FrameQuote(quoteText: "用電量時間軸圖", notes: "單位 KWH",),
          Expanded( child: 
            WeeklyConsumptionLineChart(
              data: viewModel.weeklySumOfElectricityConsumptionDataList,
              cmpLine: viewModel.lastWeekSumOfElectricityConsumptionDataList,
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
          const FrameQuote(quoteText: "各監測點數據圖", notes: "單位 KWH",),
          Expanded(
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 8,
              ),
              itemCount: source.length,
              itemBuilder: (context, index) {
                return ConsumptionDetailGridView(
                  label: source[index].index,
                  dayConsumption: (source[index] as ConsumptionSearchNode).dayConsumption,
                  monthConsumption: (source[index] as ConsumptionSearchNode).monthConsumption,
                  averageMonthConsumptionPerMonth: (source[index] as ConsumptionSearchNode).averageMonthConsumptionPerMonth,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget overViewFrame(){
    ConsumptionSearchNode dataSource = viewModel.getOverAllData!;
    // debugPrint(dataSource.toString());
    final data = [{
        "title" : "總用電量",
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
    ];
    return DashboardFrameCard(
      elevation: 0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FrameQuote(
              quoteText: "總用電量分佈(圓餅圖)",
            ),
            ConsumptionPieChart(
              dataSource: dataSource.toProportionList(),
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

  Widget tableViewFrame(){
    return DashboardFrameCard(                            // table view
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // const 
          Row(
            children: [
              const FrameQuote(quoteText: "用電量表格總覽", color: Colors.amber,),
              const Spacer(flex: 1,),
              Expanded(
                flex: 2,
                child: TabBar(
                  labelColor: Colors.amber,
                  dividerColor: Colors.amber.withOpacity(0.3),
                  automaticIndicatorColorAdjustment: false,
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.amber,
                        width: 2,
                      ),
                    ),
                  ),
                  indicatorPadding: EdgeInsets.zero,
                  // indicatorColor: Colors.amber,
                  controller: tabController,
                  tabs: const [
                    Tab(
                      icon: Row(
                        children: [
                          Text("各監測點數據紀錄"),
                          Icon(Icons.data_exploration),
                        ],
                      ),),
                      Tab(
                      icon: Row(
                        children: [
                          Text("群組數據點累積紀錄"),
                          Icon(Icons.data_exploration),
                        ],
                      ),),
                ]),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                ElectricityConsumptionDataGrid(
                  dataSource: viewModel.electricityConsumptionDataList,
                ),
                SumOfElectricityConsumptionDataGrid(
                  dataSource: viewModel.sumOfElectricityConsumptionDataList,
                )
              ]),
          )
        ],
      )
    );
  }

  Widget loadingView(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget normalScreenSizeView(BoxConstraints constraints){
    return !viewModel.isDashboardView
      ? tableViewFrame()
      : Row( 
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

  Widget mediumScreenSizeView(BoxConstraints constraints){
    return !viewModel.isDashboardView
      ? tableViewFrame()
      : SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight,
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

  Widget smallScreenSizeView(BoxConstraints constraints){
    return !viewModel.isDashboardView
      ? tableViewFrame()
      : Column(
        children: [
          // overViewFrame(viewModel),
          Expanded(
            flex: 6,
            child: PageView(
              children: [
                overViewFrame(),
                groupDetailDataFrame()
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: PageView(
              children: [
                consumptionTimelineChartFrame(),
                errorReportTableView(),
              ],
            ),
          ),
        ],
      );
  }

  Widget noneSupportScreenSizeView(){
    return Center(
      child: Text("layout not support", style: DashboardText.labelLarge(context)),
    );
  }

  Widget noneDataDialogView(){
    return Center(
      child: Text("無資料紀錄 確認伺服器連線狀態", style: DashboardText.labelLarge(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ElectricityConsumptionDashboardViewModel>.value(
      value: viewModel,
      // create: (context) => ElectricityConsumptionDashboardViewModel(),
      child: Consumer<ElectricityConsumptionDashboardViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: const DashboardAppBar(title: "用電量總覽"),
          drawer: const DashboardDrawer(),
          body: DashboardPadding.small(
            child: SizedBox.expand(
                child: DashboardPadding.small(
                  child: Column(
                    children: [
                      viewModel.loadingState == LoadingState.free
                      ? DashboardSearchBar(
                        children: [
                          DateFilterList(), 
                          LevelFilterList(
                            treeSearchCard: TreeSearchCard(
                              searchTree: viewModel.getTodayConsumptionDataSearchTree!,
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
                          ), const Spacer(), tableSwitcher(),            
                        ]              
                      ) : const SizedBox.shrink(),
                      Expanded(
                        child: DashboardFrameCard(
                          elevation: 3,
                          child: viewModel.loadingState == LoadingState.loading
                          ? loadingView()
                          : viewModel.sumOfElectricityConsumptionDataList.isEmpty || viewModel.getTodayConsumptionDataSearchTree == null
                            ? noneDataDialogView()
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
