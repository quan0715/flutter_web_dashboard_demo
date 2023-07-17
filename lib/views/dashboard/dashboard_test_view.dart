import 'package:flutter/material.dart';
import 'package:prologium_project_demo/view_model/dashboard/dashboard_view_model.dart';
import 'package:prologium_project_demo/views/chart/components/frame_quote.dart';
import 'package:prologium_project_demo/views/common/color.dart';
import 'package:prologium_project_demo/views/common/divider.dart';
import 'package:prologium_project_demo/views/common/padding.dart';
import 'package:prologium_project_demo/views/common/sizedbox.dart';
import 'package:prologium_project_demo/views/common/text.dart';
import 'package:prologium_project_demo/views/home_page_base.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashBoardTestView extends StatefulWidget {
  const DashBoardTestView({super.key});

  @override
  State<DashBoardTestView> createState() => _DashBoardTestViewState();
}

class _DashBoardTestViewState extends State<DashBoardTestView> {
  Widget getFactoryInfoFrame() {
    return Consumer<DashboardViewModel>(builder: (context, vm, _) {
      // ElectricityFlowData data = vm.currentSelectedFactoryData;
      return DashboardPadding.object(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // select factory
            DropdownButton<int>(
              borderRadius: BorderRadius.circular(5.0),
              elevation: 0,
              underline: Container(),
              items: [
                ...vm.factoryName
                    .map((data) => DropdownMenuItem<int>(
                          value: vm.factoryName.indexOf(data),
                          child: RawChip(
                              // avatarBorder: Border.all(color: DashboardColor.error(context), width: 1.5),
                              avatar: Text(data[2]),
                              label: Text(data,
                                  style: DashboardText.titleLarge(context))),
                        ))
                    .toList(),
              ],
              onChanged: (index) => {
                vm.currentSelectedFactoryIndex = index!,
              },
              value: vm.currentSelectedFactoryIndex,
            ),
            const DashboardSizedBox(
              width: 20,
            ),
            // select category
            DropdownButton<int>(
              borderRadius: BorderRadius.circular(5.0),
              elevation: 0,
              underline: Container(),
              items: [
                ...vm.categoryName
                    .map((data) => DropdownMenuItem<int>(
                          value: vm.categoryName.indexOf(data),
                          child: RawChip(
                              avatar: Icon(vm
                                  .categoryIcon[vm.categoryName.indexOf(data)]),
                              label: Text(data,
                                  style: DashboardText.titleLarge(context))),
                        ))
                    .toList(),
              ],
              onChanged: (index) => {
                vm.currentSelectedCategoryIndex = index!,
              },
              value: vm.currentSelectedCategoryIndex,
            ),
          ],
        ),
      );
    });
  }

  // Widget allAreaDataCardFrame() {
  //   return Consumer<DashboardViewModel>(
  //       builder: (context, vm, _) {
  //     // ElectricityFlowData data = vm.currentSelectedFactoryData;
  //     return DashboardPadding.object(
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             // FrameQuote(quoteText: "${vm.queryName} 分區數據", notes:  "單位: kWH"),
  //             GridView.builder(
  //               physics: const AlwaysScrollableScrollPhysics(),
  //               shrinkWrap: true,
  //               scrollDirection: Axis.vertical,
  //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 1,
  //                 childAspectRatio: 2.1,
  //                 mainAxisSpacing: 6,
  //                 crossAxisSpacing: 8,
  //               ),
  //               itemCount: vm.subAmmeterData.length,
  //               itemBuilder: (context, index) {
  //                 return InfoCardGridView.workspace(
  //                     context, vm.subAmmeterData[index]);
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  // Widget getPieChartFrame() {
  //   return Consumer<DashboardViewModel>(
  //       builder: (context, vm, _) {
  //     return DashboardPadding.object(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           FrameQuote(
  //             quoteText: "指標",
  //             color: DashboardColor.incorrect,
  //             notes: "單位",
  //           ),
  //           // getQuoteSection("${vm.queryName} 優良指標"),
  //           ElectricityDistributionPieChartPieChart(
  //             chartData: vm.weaklyAccumulatedElectricityFlow,
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  // Widget getInfoCardListFrame() {
  //   return Consumer<DashboardViewModel>(
  //     builder: (context, vm, _) => DashboardPadding.object(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           // Spacer(),
  //           InfoCard(
  //               title: "時段用電總量",
  //               value: vm.currentSelectedAmmeterEData.currentElectricityFlow,
  //               unit: "kWH",
  //               errorReport: (value) {
  //                 return vm.currentSelectedAmmeterEData
  //                     .currentElectricityFlowError();
  //               }),
  //           InfoCard(
  //             title: "本月用電",
  //             value: vm.currentSelectedAmmeterEData
  //                 .monthlyAccumulatedElectricityFlow,
  //             unit: "kWH",
  //             errorReport: (value) =>
  //                 vm.currentSelectedAmmeterEData.monthElectricityFlowError(),
  //           ),
  //           InfoCard(
  //             title: "本月平均每小時用電",
  //             value: vm.currentSelectedAmmeterEData
  //                 .monthlyAccumulatedElectricityFlowPerHour,
  //             unit: "kWH",
  //             errorReport: (value) =>
  //                 value >
  //                 vm.currentSelectedAmmeterEData
  //                     .lastMonthlyAccumulatedElectricityFlowPerHour,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget getLineChartFrame() {
  //   return Consumer<DashboardViewModel>(
  //       builder: (context, electricityDataDashboardViewModel, child) =>
  //           DashboardPadding.object(
  //               child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 FrameQuote( quoteText:  "${electricityDataDashboardViewModel.queryName} 用電趨勢圖",notes: "最近7天",),
  //                 ElectricityTimeLineChart(
  //                   data: electricityDataDashboardViewModel
  //                       .currentSelectedAmmeterEData
  //                       .weaklyAccumulatedElectricityFlow,
  //                   cmpLine: electricityDataDashboardViewModel
  //                       .currentSelectedAmmeterEData
  //                       .lastWeaklyAccumulatedElectricityFlow,
  //                 ),
  //               ],
  //             ),
  //           )));
  // }

  // Widget getErrorDataGridFrame() {
  //   return Consumer<DashboardViewModel>(
  //       builder: (context, electricityDataDashboardViewModel, child) =>
  //           DashboardPadding.object(
  //               child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 FrameQuote(quoteText: "${electricityDataDashboardViewModel.queryName} 用電量錯誤回報"),
  //                 DashboardSizedBox.small(),
  //                 const ErrorReportDataGrid(),
  //               ],
  //             ),
  //           )));
  // }

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

  Widget qualityIndexFrame() {
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) => Card(
          elevation: 0,
          child: DashboardPadding.object(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FrameQuote( quoteText: "${vm.dashboardTitle} 指標數據"),
                  DashboardSizedBox.small(),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Card(
                      child: DashboardPadding.small(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          // FrameQuote(quoteText: "PM 2.5", notes: "單位: ppm", color:  DashboardColor.correct),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.stretch, 
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("PM 2.5",style: DashboardText.titleLarge(context)),
                                    Text("Excellent",style: DashboardText.headLineLarge(context)),
                                    Text("0.0 - 15.4(μg/m3 )",style: DashboardText.bodyMedium(context).copyWith(color: DashboardText.headLineMedium(context).color!.withOpacity(0.5))),
                                  ],
                                )),
                              Expanded(
                                child: Center(
                                  child: SfRadialGauge(axes: <RadialAxis>[
                                    RadialAxis(
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 0.8,
                                      startAngle: 120,
                                      endAngle: 60,
                                      minimum: 0,
                                      maximum: 50,
                                      axisLineStyle: AxisLineStyle(
                                        thickness: 0.2,
                                        cornerStyle: CornerStyle.bothCurve,
                                        color: DashboardColor.correct.withOpacity(0.2),
                                        thicknessUnit: GaugeSizeUnit.factor,
                                      ),
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                            color: DashboardColor.correct,
                                            value: 30,
                                            cornerStyle: CornerStyle.bothCurve,
                                            width: 0.2,
                                            sizeUnit: GaugeSizeUnit.factor,
                                            enableAnimation: true,
                                            animationDuration: 20,
                                            animationType: AnimationType.linear
                                        ),
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            positionFactor: 0.1,
                                            angle: 90,
                                            widget: Text(
                                              "30",
                                              style: DashboardText.bodyLarge(context),
                                            )
                                        ),
                                        GaugeAnnotation(
                                          angle: 114,
                                          positionFactor: 1.0,
                                          widget:
                                              Text('0', style: TextStyle(fontSize: 10)),
                                        ),
                                        GaugeAnnotation(
                                          angle: 66,
                                          positionFactor: 1.0,
                                          widget: Text('50',
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                      ]
                                    ),],
                                    enableLoadingAnimation: true,
                                    )
                                )
                              )
                            ]
                          )
                          ],
                        ),
                      )),
                  )
                ],
              ),
            ),
          ),
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardViewModel>(
      create: (context) => DashboardViewModel(),
      child: HomePageBaseView(
          body: DashboardPadding.object(
        child: Card(
          child: DashboardPadding.medium(
            child: SizedBox(
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
                        Expanded(flex: 3, child: qualityIndexFrame()),
                        Expanded(
                          flex: 8,
                          child: Card(
                              elevation: 0,
                              child: Column(
                                children: [
                                  DashboardPadding.object(
                                      child: const FrameQuote(
                                    quoteText: "監測點數據",
                                    child: Text("監測站詳細數據與時間圖"),
                                  )),
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
