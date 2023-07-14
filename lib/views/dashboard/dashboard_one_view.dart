import 'package:flutter/material.dart';
import 'package:prologium_project_demo/view_model/dashboard/dashboard_view_model.dart';
import 'package:prologium_project_demo/views/common/padding.dart';
import 'package:prologium_project_demo/views/home_page_base.dart';
import 'package:provider/provider.dart';

class DashBoardOneView extends StatefulWidget {
  const DashBoardOneView({super.key});

  @override
  State<DashBoardOneView> createState() => _DashBoardOneViewState();
}

class _DashBoardOneViewState extends State<DashBoardOneView> {
  // Widget getNotifyLabel() {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       RawChip(
  //         visualDensity: VisualDensity.compact,
  //         avatar: CircleAvatar(
  //           backgroundColor: DashboardColor.correct,
  //           radius: 6,
  //         ),
  //         label: const Text("正常"),
  //         side: BorderSide.none,
  //       ),
  //       DashboardSizedBox.small(),
  //       RawChip(
  //         visualDensity: VisualDensity.compact,
  //         avatar: CircleAvatar(
  //           backgroundColor: DashboardColor.incorrect,
  //           radius: 6,
  //         ),
  //         label: const Text("異常"),
  //         side: BorderSide.none,
  //       ),
  //     ],
  //   );
  // }

  // Widget chartCardView(BuildContext context) {
  //   return Consumer<ElectricityDataDashboardViewModel>(
  //     builder: (context, vm, child) => Padding(
  //       padding: const EdgeInsets.all(0),
  //       child: Card(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             DashboardPadding.medium(
  //               child: getHeadlineSection(
  //                   vm.currentSelectedFactoryData.factoryName),
  //             ),
  //             DashboardDivider.medium(),
  //             Row(
  //               mainAxisSize: MainAxisSize.max,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Expanded(
  //                     flex: 3,
  //                     child: DashboardPadding.object(
  //                         child: Column(
  //                       children: [
  //                         getQuoteSection("即時用電量趨勢圖(最近8小時)"),
  //                         ElectricityTimeLineChart(data: vm.lineChartData),
  //                       ],
  //                     ))),
  //                 Expanded(
  //                   flex: 2,
  //                   child: DashboardPadding.object(
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             getQuoteSection("實際用電數據"),
  //                             const Spacer(),
  //                             getNotifyLabel(),
  //                           ],
  //                         ),
  //                         InfoCard(
  //                             title: "今日用電總量",
  //                             value: vm.currentSelectedFactoryData.todayElectricityFlow,
  //                             unit: "kWH"),
  //                         InfoCard(
  //                             title: "本月用電",
  //                             value: vm.currentSelectedFactoryData.monthElectricityFlow,
  //                             unit: "kWH"),
  //                         InfoCard(
  //                           title: "本月平均每小時用電",
  //                           value: vm.currentSelectedFactoryData .monthElectricityFlowPerHour,
  //                           unit: "kWH",
  //                           errorReport: (value) =>
  //                               value > vm.currentSelectedFactoryData.lastMonthElectricityFlowPerHour,
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               mainAxisSize: MainAxisSize.max,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Expanded(
  //                     flex: 3,
  //                     child: DashboardPadding.object(
  //                         child: Column(
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Column(
  //                               children: [
  //                                 getQuoteSection("全場總電量使用分佈"),
  //                                 ElectricityDistributionPieChartPieChart(
  //                                   chartData: ElectricityAmountProportion
  //                                       .generateFakeData(),
  //                                 )
  //                               ],
  //                             ),
  //                             Column(
  //                               children: [
  //                                 getQuoteSection("廠務總電量使用分佈"),
  //                                 ElectricityDistributionPieChartPieChart(
  //                                   chartData: ElectricityAmountProportion
  //                                       .generateFakeData1(),
  //                                 )
  //                               ],
  //                             ),
  //                             Column(
  //                               children: [
  //                                 getQuoteSection("產線總電量使用分佈"),
  //                                 ElectricityDistributionPieChartPieChart(
  //                                   chartData: ElectricityAmountProportion
  //                                       .generateFakeData2(),
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ))),
  //                 Expanded(
  //                   flex: 2,
  //                   child: DashboardPadding.object(
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             getQuoteSection("各產線用電量"),
  //                             const Spacer(),
  //                             getNotifyLabel(),
  //                           ],
  //                         ),
  //                         InfoCard(
  //                           title: "產線1",
  //                           value: vm.currentSelectedFactoryData
  //                               .monthElectricityFlowPerHour,
  //                           unit: "kWH",
  //                           errorReport: (value) =>
  //                               value >
  //                               vm.currentSelectedFactoryData
  //                                   .lastMonthElectricityFlowPerHour,
  //                         ),
  //                         InfoCard(
  //                           title: "產線2",
  //                           value: vm.currentSelectedFactoryData
  //                               .monthElectricityFlowPerHour,
  //                           unit: "kWH",
  //                           errorReport: (value) =>
  //                               value >
  //                               vm.currentSelectedFactoryData
  //                                   .lastMonthElectricityFlowPerHour,
  //                         ),
  //                         InfoCard(
  //                           title: "產線3",
  //                           value: vm.currentSelectedFactoryData
  //                               .monthElectricityFlowPerHour,
  //                           unit: "kWH",
  //                           errorReport: (value) =>
  //                               value >
  //                               vm.currentSelectedFactoryData
  //                                   .lastMonthElectricityFlowPerHour,
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget getHeadlineSection(String text) {
  //   return Text(
  //     text,
  //     style: Theme.of(context)
  //         .textTheme
  //         .headlineMedium!
  //         .copyWith(fontWeight: FontWeight.bold),
  //   );
  // }

  // Widget getQuoteSection(String text) {
  //   return DashboardPadding.small(
  //     child: Row(
  //       children: [
  //         Container(
  //             width: 4,
  //             height: 20,
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).colorScheme.primary,
  //               borderRadius: BorderRadius.circular(5),
  //             )),
  //         DashboardSizedBox.small(),
  //         Text(
  //           text,
  //           style: Theme.of(context)
  //               .textTheme
  //               .headlineSmall!
  //               .copyWith(fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return HomePageBaseView(
        body: SingleChildScrollView(
            child: DashboardPadding.large(
        child: Center(
          child: Text("施工中"),
          
        ),
            ),
          ));
  }
}
