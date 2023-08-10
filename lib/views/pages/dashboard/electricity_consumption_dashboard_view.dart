import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_dashboard/models/ammeter_model.dart';
import 'package:web_dashboard/models/test/fake_data.dart';
import 'package:web_dashboard/view_model/dashboard/electricity_consumption_dashboard_view_model.dart';
import 'package:web_dashboard/views/components/chart/electricity_distribute_pie_chart.dart';
import 'package:web_dashboard/views/components/chart/electricity_time_line_chart.dart';
import 'package:web_dashboard/views/components/data/error_report_table/data_grid.dart';
import 'package:web_dashboard/views/components/chart/info_card.dart';
import 'package:web_dashboard/views/components/chart/info_card_grid_view.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';
import 'package:web_dashboard/views/theme/theme.dart';

import 'package:provider/provider.dart';

class ElectricityConsumptionDashboard extends StatefulWidget {
  const ElectricityConsumptionDashboard({super.key});

  @override
  State<ElectricityConsumptionDashboard> createState() => _ElectricityConsumptionDashboardState();
}


class HeadLineDropdownView extends StatelessWidget {
  const HeadLineDropdownView({super.key, required this.data});
  final AmmeterModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(data.name, style: DashboardText.titleLarge(context)),
        DashboardSizedBox.medium(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (data.location.isNotEmpty)
              RawChip(
                avatar: const Icon(Icons.location_city_outlined),
                visualDensity: VisualDensity.compact,
                label: Text(data.location),
                labelStyle: DashboardText.labelMedium(context),
              ),
            DashboardSizedBox.medium(),
          ],
        ),
      ],
    );
  }
}

class _ElectricityConsumptionDashboardState extends State<ElectricityConsumptionDashboard> {
 
  Widget getFactoryInfoFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, vm, _) {
      return DashboardPadding.object(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButton<int>(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              borderRadius: BorderRadius.circular(5.0),
              focusColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              underline: Container(),
              items: [
                ...vm.l1WorkspaceHeaderList
                    .map((data) => DropdownMenuItem(
                          value: vm.l1WorkspaceHeaderList.indexOf(data),
                          child: HeadLineDropdownView(data: data),
                        ))
                    .toList(),
              ],
              onChanged: (index) => {
                vm.currentL1SelectedIndex = index!,
              },
              value: vm.currentSelectedL1Index,
            ),
            vm.currentSelectedL1Index != 0
                ? DropdownButton<int>(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 10.0),
                    borderRadius: BorderRadius.circular(5.0),
                    focusColor: Theme.of(context).colorScheme.surface,
                    elevation: 0,
                    underline: Container(),
                    items: [
                      ...vm.l2WorkspaceHeaderList
                          .map((AmmeterModel data) => DropdownMenuItem(
                                value: vm.l2WorkspaceHeaderList.indexOf(data),
                                child: Text(
                                    // vm.l2WorkspaceHeaderList.indexOf(data) == 0
                                    // ?
                                    // :
                                    data.name),
                              ))
                          .toList()
                    ],
                    onChanged: (value) => {
                      vm.currentL2SelectedIndex = value!,
                    },
                    value: vm.currentSelectedL2Index,
                  )
                : Container(),
                const Spacer(),
                Text("更新時間 ${DashBoardFormat.timeWithSecond(time)}", style: DashboardText.labelLarge(context).copyWith(
                  color: DashboardColor.onSurface(context)
                ))

            //getInfoCardListFrame(),
          ],
        ),
      );
    });
  }

  Widget allAreaDataCardFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(builder: (context, vm, _) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            FrameQuote(quoteText: "${vm.queryName} 分區數據", notes: "單位: kWH"),
            GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.8,
                mainAxisSpacing: 6,
                crossAxisSpacing: 8,
              ),
              itemCount: vm.subAmmeterData.length,
              itemBuilder: (context, index) {
                return InfoCardGridView.workspace(
                    context, vm.subAmmeterData[index]);
              },
            ),
          ],
        )
      ));
  }

  Widget getPieChartFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, vm, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FrameQuote(quoteText: '${vm.queryName} 總電量使用分佈'),
          ElectricityDistributionPieChartPieChart(
            chartData: vm.weaklyAccumulatedElectricityFlow,
          ),
        ],
      );
    });
  }

  Widget getInfoCardListFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
      builder: (context, vm, _) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Spacer(),
          InfoCard(
              title: "時段用電總量",
              value: vm.currentSelectedAmmeterEData.currentElectricityFlow,
              unit: "kWH",
              errorReport: (value) {
                return vm.currentSelectedAmmeterEData
                    .currentElectricityFlowError();
              }),
          InfoCard(
            title: "本月用電",
            value: vm.currentSelectedAmmeterEData
                .monthlyAccumulatedElectricityFlow,
            unit: "kWH",
            errorReport: (value) =>
                vm.currentSelectedAmmeterEData.monthElectricityFlowError(),
          ),
          InfoCard(
            title: "本月平均每小時用電",
            value: vm.currentSelectedAmmeterEData
                .monthlyAccumulatedElectricityFlowPerHour,
            unit: "kWH",
            errorReport: (value) =>
                value >
                vm.currentSelectedAmmeterEData
                    .lastMonthlyAccumulatedElectricityFlowPerHour,
          )
        ],
      ),
    );
  }

  Widget getLineChartFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
      builder: (context, electricityDataDashboardViewModel, child) =>SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FrameQuote(quoteText: "${electricityDataDashboardViewModel.queryName} 用電趨勢圖(最近7天)"),
              ElectricityTimeLineChart(
                data: electricityDataDashboardViewModel
                    .currentSelectedAmmeterEData
                    .weaklyAccumulatedElectricityFlow,
                cmpLine: electricityDataDashboardViewModel
                    .currentSelectedAmmeterEData
                    .lastWeaklyAccumulatedElectricityFlow,
              ),
            ],
          ),
        )
      );
  }

  Widget getErrorDataGridFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, electricityDataDashboardViewModel, child) =>
            DashboardPadding.object( child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FrameQuote(quoteText: "${electricityDataDashboardViewModel.queryName} 用電量錯誤回報"),
                  DashboardSizedBox.small(),
                  const ErrorReportDataGrid(),
                ],
              ),
            )));
  }

  Widget getNotifyLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RawChip(
          visualDensity: VisualDensity.compact,
          avatar: CircleAvatar(
            backgroundColor: DashboardColor.correct,
            radius: 5.5,
          ),
          label: const Text("正常"),
          labelStyle: DashboardText.labelLarge(context),
          side: BorderSide.none,
        ),
        DashboardSizedBox.small(),
        RawChip(
          visualDensity: VisualDensity.compact,
          avatar: CircleAvatar(
            backgroundColor: DashboardColor.incorrect,
            radius: 5.5,
          ),
          label: const Text("異常"),
          side: BorderSide.none,
          labelStyle: DashboardText.labelLarge(context),
        ),
      ],
    );
  }

  // update every 1 minutes
  // final Duration duration = const Duration(seconds: 5);
  // Timer.periodic(duration, (timer) { }),

  late Timer _timer;
  ElectricityDataDashboardViewModel? vm;
  DateTime time = DateTime.now();

  @override
  void initState() {
    super.initState();
    // _startTimer();
  }

  @override
  void dispose() {
    // _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        debugPrint("timer");
        time = DateTime.now();
        vm = ElectricityDataDashboardViewModel(ammeterModel: FakeData.generateFakeData());
      });
    });
  }

  // 取消定时器的函数
  void _cancelTimer() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(title: "用電紀錄儀表板",),
      drawer: const DashboardDrawer(),
      body: ChangeNotifierProvider<ElectricityDataDashboardViewModel>.value(
      value: vm ?? ElectricityDataDashboardViewModel(ammeterModel: FakeData.generateFakeData()),
      child: Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, vm, _) => 
          DashboardPadding.object(
          child: DashboardFrameCard(
            elevation: 1,
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(flex: 1, child: getFactoryInfoFrame()),
                  DashboardDivider.small(),
                  DashboardSizedBox.large(),
                  Expanded(
                    flex: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: DashboardFrameCard(
                            elevation: 0,
                            child: SizedBox.expand(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    getPieChartFrame(),
                                    DashboardDivider.small(),
                                    DashboardSizedBox.small(),
                                    getInfoCardListFrame(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 2,
                          child: DashboardFrameCard(
                            elevation: 0,
                            child: SizedBox.expand(
                              child: SingleChildScrollView(
                                child: allAreaDataCardFrame(),
                              ),
                            )
                          ),
                        ),
                        Expanded( flex: 4,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: DashboardFrameCard(
                                      elevation: 0,
                                      child: getLineChartFrame())),
                              Expanded(
                                  flex: 1,
                                  child: DashboardFrameCard(
                                      elevation: 0,
                                      child: getErrorDataGridFrame())),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
              ),
      ),
      ));
  }
}
