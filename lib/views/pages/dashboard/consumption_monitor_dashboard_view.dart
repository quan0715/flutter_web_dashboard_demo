import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/search_node.dart';
import 'package:web_dashboard/models/state.dart';
import 'package:web_dashboard/views/components/chart/info_card.dart';
import 'package:web_dashboard/views/components/chart/sum_consumption_detail_grid_view.dart';
import 'package:web_dashboard/views/components/chart/sum_consumption_pie_chart.dart';
import 'package:web_dashboard/views/components/chart/weakly_consumption_line_chart.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/data_grid.dart';
import 'package:web_dashboard/view_model/dashboard/electricity_consumption_view_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_grid.dart';
import 'package:web_dashboard/views/components/data/sum_consumption_table.dart/data_grid.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/widget/dashboard_search_bar.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class ConsumptionMonitorDashboardView extends StatefulWidget {
  const ConsumptionMonitorDashboardView({Key? key}) : super(key: key);

  @override
  State<ConsumptionMonitorDashboardView> createState() => _ConsumptionMonitorDashboardViewState();
}

class _ConsumptionMonitorDashboardViewState extends State<ConsumptionMonitorDashboardView> with SingleTickerProviderStateMixin{
  late final TabController tabController;

  @override
  initState(){
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  dispose(){
    tabController.dispose();
    super.dispose();
  }
  
  Widget errorReportTableView(ElectricityConsumptionDashboardViewModel viewModel){
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

  Widget consumptionTimelineChartFrame(ElectricityConsumptionDashboardViewModel viewModel){
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

  Widget groupDetailDataFrame(ElectricityConsumptionDashboardViewModel viewModel){
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

  Widget overViewFrame(ElectricityConsumptionDashboardViewModel viewModel){
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FrameQuote(
            quoteText: "總用電量分佈(圓餅圖)",
          ),
          ConsumptionPieChart(
            dataSource: dataSource.toProportionList(),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: data.map<Widget>(
                  (d) => InfoCard(
                    title: d["title"] as String,
                    value: d["value"] as int,
                    unit: d["unit"] as String,
                  )
                ).toList()
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableViewFrame(ElectricityConsumptionDashboardViewModel viewModel){
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ElectricityConsumptionDashboardViewModel>(
      create: (context) => ElectricityConsumptionDashboardViewModel()..init(),
      child: Consumer<ElectricityConsumptionDashboardViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: const DashboardAppBar(
            title: "用電量總覽",
          ),
          drawer: const DashboardDrawer(),
          body: DashboardPadding.small(
            child: SizedBox.expand(
                child: DashboardPadding.small(
                  child: Column(
                    children: [
                      const DashboardSearchBar(),
                      Expanded(
                        child: DashboardFrameCard(
                          elevation: 3,
                          child: viewModel.loadingState == LoadingState.loading
                          ? loadingView()
                          : viewModel.sumOfElectricityConsumptionDataList.isEmpty
                            ? Center(child: Text("無資料紀錄", style: DashboardText.labelLarge(context),),)
                            : !viewModel.isDashboardView
                                ? tableViewFrame(viewModel)
                                : Row( children: [
                                    Expanded(flex: 1, child: overViewFrame(viewModel)),
                                    Expanded(flex: 1, child: groupDetailDataFrame(viewModel)),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(flex: 3, child: consumptionTimelineChartFrame(viewModel)),
                                          Expanded(flex: 2, child: errorReportTableView(viewModel)),
                                        ],
                                      ),
                                    )],
                                  )
                            ))
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
