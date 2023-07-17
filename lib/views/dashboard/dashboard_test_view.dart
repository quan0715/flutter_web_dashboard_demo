import 'package:flutter/material.dart';
import 'package:prologium_project_demo/models/ammeter_model.dart';
import 'package:prologium_project_demo/models/electricity_amount_proportion.dart';
import 'package:prologium_project_demo/models/electricity_flow_data.dart';
import 'package:prologium_project_demo/models/fake_data.dart';
import 'package:prologium_project_demo/models/workspace_model.dart';
import 'package:prologium_project_demo/view_model/dashboard/dashboard_view_model.dart';
import 'package:prologium_project_demo/views/chart/ammeter_error_report_col.dart';
import 'package:prologium_project_demo/views/chart/electricity_distibute_pie_chart.dart';
import 'package:prologium_project_demo/views/chart/electricity_time_line_chart.dart';
import 'package:prologium_project_demo/views/chart/error_report_grid.dart';
import 'package:prologium_project_demo/views/chart/info_card.dart';
import 'package:prologium_project_demo/views/chart/info_card_grid_view.dart';
import 'package:prologium_project_demo/views/common/color.dart';
import 'package:prologium_project_demo/views/common/divider.dart';
import 'package:prologium_project_demo/views/common/padding.dart';
import 'package:prologium_project_demo/views/common/sizedbox.dart';
import 'package:prologium_project_demo/views/home_page_base.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
        getHeadlineSection(data.name, context),
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
                // side: BorderSide.none,
              ),
            DashboardSizedBox.medium(),
            // RawChip(
            //   avatar: Text(data.electricityType.split(' ').first),
            //   visualDensity: VisualDensity.compact,
            //   label: Text(data.electricityType.split(' ')[1]),
            //   labelStyle: getRawChipStyle(context),
            //   // side: BorderSide.none,
            // ),
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
    return Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, vm, _) {
      // ElectricityFlowData data = vm.currentSelectedFactoryData;
      return DashboardPadding.object(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  getQuoteSection("${vm.queryName} 分區數據"),
                  const Spacer(),
                  Text(
                    "單位: kWH",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        // fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7)),
                  ),
                  const Spacer(),
                ],
              ),
              // Spacer(),
              GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                // physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                //     maxCrossAxisExtent: 400,
                //     mainAxisSpacing: 6,
                //     crossAxisSpacing: 8,
                //     childAspectRatio: 2.2
                // ),
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
              // Spacer(),
              // ListView.builder(
              //   itemExtent: 400,
              //   scrollDirection: Axis.vertical,
              //   shrinkWrap: true,
              //   itemBuilder: (context, index){
              //     return InfoCardGridView.workspace(
              //         context, vm.workspaceData[index]);
              //   }
              // )
              // Spacer()
            ],
          ),
        ),
      );
    });
  }

  Widget getPieChartFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, vm, _) {
      return DashboardPadding.object(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getQuoteSection("${vm.queryName} 總電量使用分佈"),
            ElectricityDistributionPieChartPieChart(
              chartData: vm.weaklyAccumulatedElectricityFlow,
            ),
          ],
        ),
      );
    });
  }

  Widget getInfoCardListFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
      builder: (context, vm, _) => DashboardPadding.object(
        child: Column(
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
      ),
    );
  }

  Widget getLineChartFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, electricityDataDashboardViewModel, child) =>
            DashboardPadding.object(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  getQuoteSection(
                      "${electricityDataDashboardViewModel.queryName} 用電趨勢圖(最近7天)"),
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
            )));
  }

  Widget getErrorDataGridFrame() {
    return Consumer<ElectricityDataDashboardViewModel>(
        builder: (context, electricityDataDashboardViewModel, child) =>
            DashboardPadding.object(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  getQuoteSection(
                      "${electricityDataDashboardViewModel.queryName} 用電量錯誤回報"),
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
          labelStyle: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
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
          labelStyle: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget getHeadlineSection(String text) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget getQuoteSection(String text) {
    return DashboardPadding.small(
      child: Row(
        children: [
          Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(5),
              )),
          DashboardSizedBox.small(),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomePageBaseView(
        body: ChangeNotifierProvider<ElectricityDataDashboardViewModel>(
      create: (context) => ElectricityDataDashboardViewModel(
          ammeterModel: FakeData.generateFakeData()),
      child:
          // Consumer<ElectricityDataDashboardViewModel>(
          //   builder: (context, electricityDataDashboardViewModel, child) =>
          DashboardPadding.object(
        child: Card(
          child: DashboardPadding.medium(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                          child: Card(
                            elevation: 0,
                            child: Column(
                              children: [
                                getPieChartFrame(),
                                DashboardDivider.small(),
                                DashboardSizedBox.small(),
                                // getNotifyLabel(),
                                getInfoCardListFrame(),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Card(
                              elevation: 0,
                              child: Column(
                                children: [
                                  allAreaDataCardFrame(),
                                  const Spacer()
                                ],
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Card(
                                      elevation: 0,
                                      child: getLineChartFrame())),
                              Expanded(
                                  flex: 1,
                                  child: Card(
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
