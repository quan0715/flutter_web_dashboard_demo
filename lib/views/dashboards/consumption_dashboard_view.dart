import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/theme/format.dart';
import 'package:web_dashboard/theme/padding.dart';
import 'package:web_dashboard/view_model/dashboard/electricity_consumption_view_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_grid.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/widget/dashboard_search_bar.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';

class ConsumptionReportView extends StatelessWidget {
  const ConsumptionReportView({Key? key}) : super(key: key);
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
                          child: !viewModel.isDashboardView
                          ? DashboardFrameCard(
                            // table view
                            elevation: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FrameQuote(
                                  quoteText: "用電量總覽 (表格)",
                                  notes: "更新時間: ${DashBoardFormat.time(DateTime.now())}",
                                ),
                                Expanded(
                                  child: DashboardPadding.object(
                                    child: ElectricityConsumptionDataGrid(
                                      dataSource: viewModel.electricityConsumptionDataList,
                                    ),
                                  ),
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
                              Expanded(
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
