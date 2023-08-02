import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/theme/color.dart';
import 'package:web_dashboard/theme/format.dart';
import 'package:web_dashboard/theme/padding.dart';
import 'package:web_dashboard/view_model/dashboard/electricity_consumption_view_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_grid.dart';
import 'package:web_dashboard/views/components/data/sum_electricity_consumption_table.dart/data_grid.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/widget/dashboard_search_bar.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';

class ConsumptionReportView extends StatefulWidget {
  const ConsumptionReportView({Key? key}) : super(key: key);

  @override
  State<ConsumptionReportView> createState() => _ConsumptionReportViewState();
}

class _ConsumptionReportViewState extends State<ConsumptionReportView> with SingleTickerProviderStateMixin{
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
                          child: 
                          viewModel.isLoading ? const Center(
                            child: CircularProgressIndicator(),
                          ) :
                          !viewModel.isDashboardView
                          ? DashboardFrameCard(
                            // table view
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
                          )
                          : Row(
                            children: [
                              const Expanded(
                                  flex: 1,
                                  child: DashboardFrameCard(
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        FrameQuote(
                                          quoteText: "總用電量分佈(圓餅圖)",
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: DashboardFrameCard(
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        const FrameQuote(quoteText: "各監測點數據圖", notes: "單位 KWH",),
                                        Expanded(
                                          child: GridView.builder(
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              childAspectRatio: 2.2,
                                              mainAxisSpacing: 6,
                                              crossAxisSpacing: 8,
                                            ),
                                            itemCount: viewModel.electricityConsumptionDataList.length,
                                            itemBuilder: (context, index) {
                                              return DashboardFrameCard(
                                                child: Center(
                                                  child: Text(viewModel.electricityConsumptionDataList[index].sumOfEnergyConsumed!.toString()),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const Expanded(
                                flex: 2,
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: DashboardFrameCard(
                                      elevation: 0,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FrameQuote(
                                            quoteText: "電量累積趨勢圖",
                                          ),
                                          Spacer()
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: DashboardFrameCard(
                                      elevation: 0,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FrameQuote(
                                            quoteText: "異常回報清單（篩）",
                                          ),
                                          Spacer()
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                ),
                              ),
                            ],
                          ),
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
