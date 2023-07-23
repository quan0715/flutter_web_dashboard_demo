import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_dashboard/models/ammeter_model.dart';
import 'package:web_dashboard/models/fake_data.dart';
import 'package:web_dashboard/view_model/dashboard/dashboard_view_model.dart';
import 'package:web_dashboard/views/chart/electricity_distribute_pie_chart.dart';
import 'package:web_dashboard/views/chart/electricity_time_line_chart.dart';
import 'package:web_dashboard/views/chart/error_report_grid.dart';
import 'package:web_dashboard/views/chart/info_card.dart';
import 'package:web_dashboard/views/chart/info_card_grid_view.dart';
import 'package:web_dashboard/views/components/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/quate.dart';
import 'package:web_dashboard/views/theme/theme.dart';
import 'package:web_dashboard/views/home_page_base.dart';
import 'package:provider/provider.dart';

class DashBoardTestView extends StatefulWidget {
  const DashBoardTestView({super.key});

  @override
  State<DashBoardTestView> createState() => _DashBoardTestViewState();
}

class HeadLineDropdownView extends StatelessWidget {
  const HeadLineDropdownView({super.key, required this.data});
  final AmmeterModel data;

  Widget getHeadlineSection(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headlineSmall!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  TextStyle getRawChipStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(fontWeight: FontWeight.bold);
  }

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
                labelStyle: getRawChipStyle(context),
              ),
            DashboardSizedBox.medium(),
          ],
        ),
      ],
    );
  }
}

class _DashBoardTestViewState extends State<DashBoardTestView> {
  Widget getFactoryInfoFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, vm, _) {
      // ElectricityFlowData data = vm.currentSelectedFactoryData;
      return DashboardPadding.object(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButton<int>(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
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
                : Spacer(),
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
                childAspectRatio: 2.1,
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
          FrameQuote(quoteText: '${vm.queryName} 總電量使用分佈', notes: "更新時間\n${DashBoardFormat.timeWithSecond(time)}",),
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
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
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
    return HomePageBaseView(
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
                        Expanded( flex: 2,
                          child: DashboardFrameCard(
                            elevation: 0,
                              child: Column(
                                children: [
                                  allAreaDataCardFrame(),
                                  const Spacer()
                                ],
                              )),
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
