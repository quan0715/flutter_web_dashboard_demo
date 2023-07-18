import 'package:flutter/material.dart';
import 'package:prologium_project_demo/models/emmission_time_data.dart';
import 'package:prologium_project_demo/view_model/dashboard/dashboard_view_model.dart';
import 'package:prologium_project_demo/views/chart/components/dashboard_frame.dart';
import 'package:prologium_project_demo/views/chart/components/frame_quote.dart';
import 'package:prologium_project_demo/views/chart/electricity_time_line_chart.dart';
import 'package:prologium_project_demo/views/chart/inspection_timelise_chart.dart';
import 'package:prologium_project_demo/views/chart/quality_inspect_card.dart';
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
      builder: (context, vm, _) => SingleChildScrollDashboardFrame(
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            FrameQuote( quoteText: "${vm.dashboardTitle} 日AQI指標"),
            AspectRatio(
              aspectRatio:3,
              child: DashboardFrame(
                color: (vm.tar["bounds"][3] as Color).withOpacity(0.07),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FrameQuote(
                        color: vm.tar["bounds"][3],
                        quoteText: "監測點總指標",
                        child: Column(
                          children: [
                            Text(vm.tar["bounds"][2], style: DashboardText.titleLarge(context)),
                          ],
                        ))
                    ),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        child: Text(vm.tar["value"].toString(), style: DashboardText.titleMedium(context))
                      )
                    )
                  ],
                )
              ),
            ),
            DashboardSizedBox.small(),
            GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: vm.data.length,
                itemBuilder: (context, index) {
                  return DashboardFrame(
                    color: (vm.data[index]["bounds"][3] as Color).withOpacity(0.07),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FrameQuote(
                          quoteText: vm.data[index]["name"] as String, 
                          color: vm.data[index]["bounds"][3] as Color,
                          
                        ),
                        SizedBox(
                          width: 100,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: QualityInspectCard(
                              category: vm.data[index]["name"],
                              detail: "",
                              label: "",
                              color: vm.data[index]["bounds"][3] as Color,
                              upperBound: vm.data[index]["bounds"][1] as double,
                              lowerBound: vm.data[index]["bounds"][0] as double,
                              value: vm.data[index]["value"],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),    
          ],
        ),
      )
      );
  }

  Widget qualityIndexFrame2() {   
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) => SingleChildScrollDashboardFrame(
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            FrameQuote( quoteText: "${vm.dashboardTitle} AQI紀錄數據"),
            DashboardSizedBox.small(),
            GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 2.3,
                ),
                itemCount: vm.data.length,
                itemBuilder: (context, index) {
                  return MaterialButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: (){
                      vm.currentSelectedCardIndex = index;
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: vm.currentSelectedCardIndex == index ? (vm.data[index]["bounds"][3] as Color).withOpacity(0.4) : Colors.transparent,
                        width: 2
                      ),
                    ), 
                    child: DashboardFrame(
                      // color:  vm.currentSelectedCardIndex == index ? (vm.data[index]["bounds"][3] as Color).withOpacity(0.07) : null,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FrameQuote(quoteText: vm.data[index]["name"] as String, color: vm.data[index]["bounds"][3] as Color,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(vm.data[index]['value'].toString(), style: DashboardText.titleLarge(context)),
                                  // DashboardSizedBox.small(),
                                  Text("當前值", style: DashboardText.titleSmall(context).copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(vm.data[index]['lastTimeValue'].toString(), style: DashboardText.titleLarge(context)),        
                                  // ashboardSizedBox.small(),
                                  Text("前次值", style:DashboardText.titleSmall(context).copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (vm.data[index]['value'] - vm.data[index]['lastTimeValue'])
                                    .toString(), style: DashboardText.titleLarge(context)
                                  ),
                                  // DashboardSizedBox.small(),
                                  Text("變動值", style:DashboardText.titleSmall(context).copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ]
                          )  
                        ],
                      ),
                    ),
                  );
                },
              ),    
          ],
        ),
      )
      );
  }

  Widget splineChartsFrame(){
    return Consumer<DashboardViewModel>(
      builder: (context, vm, child) => 
      SingleChildScrollDashboardFrame(
        elevation: 0,
        child: Column(
          children: [
            Column(
              children: [
                FrameQuote(
                  quoteText: "${vm.data[vm.currentSelectedCardIndex]["name"]} 一週趨勢", 
                  color: vm.data[vm.currentSelectedCardIndex]["bounds"][3] as Color,
                  notes: "最近7天 每8小時統計數據",
                ),
                EmissionTimeLineChart(
                  data: EmissionTimeData.generateFakeWeaklyData(),
                  unit: "ppm",
                ),
              ],
            ),
            Column(
              children: [
                FrameQuote(
                  quoteText: "${vm.data[vm.currentSelectedCardIndex]["name"]} 今日趨勢",
                  color: vm.data[vm.currentSelectedCardIndex]["bounds"][3] as Color,
                  notes: "最近1天 每8小時統計數據",
                ),
                EmissionTimeLineChart(
                  data: EmissionTimeData.generateFakeWeaklyData().sublist(0, 3),
                  unit: "ppm",
                ),
              ],
            )
          ],
          ),
      ),
    );
  }  
  
  Widget waterQualityIndexFrame() {
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) => SingleChildScrollDashboardFrame(
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            FrameQuote( quoteText: "${vm.dashboardTitle} 水觀測指標"),
            DashboardSizedBox.small(),
            GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: vm.waterData.length,
                itemBuilder: (context, index) {
                  return DashboardFrame(
                color: (vm.waterData[index]["color"] as Color).withOpacity(0.07),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FrameQuote(
                        notes: vm.waterData[index]["unit"] as String,
                        color: vm.waterData[index]["color"],
                        quoteText: "${vm.waterData[index]["name"]}",
                        child: Column(
                          children: [
                            Text(vm.waterData[index]["label"], style: DashboardText.titleLarge(context)),
                          ],
                        ))
                    ),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        child: Text(vm.waterData[index]["value"].toString(), style: DashboardText.titleSmall(context))
                      )
                    )
                  ],
                )
              );
                },
            ),    
          ],
        ),
      )
      );
  }

  Widget waterQualityIndexFrame2() {   
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) => SingleChildScrollDashboardFrame(
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            FrameQuote(quoteText: "${vm.dashboardTitle} AQI紀錄數據"),
            DashboardSizedBox.small(),
            GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 2.3,
                ),
                itemCount: vm.waterData.length,
                itemBuilder: (context, index) {
                  return MaterialButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: (){
                      vm.currentSelectedCardIndex = index;
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: vm.currentSelectedCardIndex == index ? (vm.waterData[index]["color"] as Color).withOpacity(0.4) : Colors.transparent,
                        width: 2
                      ),
                    ),
                    child: DashboardFrame(
                      // color:  vm.currentSelectedCardIndex == index ? (vm.waterData[index]["color"] as Color).withOpacity(0.07) : null,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FrameQuote(quoteText: vm.waterData[index]["name"] as String, notes: vm.waterData[index]["unit"] as String, color: vm.waterData[index]["color"] as Color,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(vm.waterData[index]['value'].toString(), style: DashboardText.titleLarge(context)),
                                  // DashboardSizedBox.small(),
                                  Text("當前值", style: DashboardText.titleSmall(context).copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(vm.waterData[index]['lastTimeValue'].toString(), style: DashboardText.titleLarge(context)),        
                                  // ashboardSizedBox.small(),
                                  Text("前次值", style:DashboardText.titleSmall(context).copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (vm.waterData[index]['value'] - vm.waterData[index]['lastTimeValue'])
                                    .toString(), style: DashboardText.titleLarge(context)
                                  ),
                                  // DashboardSizedBox.small(),
                                  Text("變動值", style:DashboardText.titleSmall(context).copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ]
                          )  
                        ],
                      ),
                    ),
                  );
                },
              ),    
          ],
        ),
      )
      );
  }

  Widget waterSplineChartsFrame(){
    return Consumer<DashboardViewModel>(
      builder: (context, vm, child) => 
      SingleChildScrollDashboardFrame(
        elevation: 0,
        child: Column(
          children: [
            Column(
              children: [
                FrameQuote(
                  quoteText: "${vm.waterData[vm.currentSelectedCardIndex]["name"]} 監測點一週趨勢", 
                  color: vm.waterData[vm.currentSelectedCardIndex]["color"] as Color,
                  notes: "最近7天 每8小時統計數據",
                ),
                EmissionTimeLineChart(
                  unit: vm.waterData[vm.currentSelectedCardIndex]["unit"],
                  data: EmissionTimeData.generateFakeWeaklyData()
                ),
              ],
            ),
            Column(
              children: [
                FrameQuote(
                  quoteText: "${vm.waterData[vm.currentSelectedCardIndex]["name"]} 監測點今日趨勢",
                  color: vm.waterData[vm.currentSelectedCardIndex]["color"] as Color,
                  notes: "最近1天 每8小時統計數據",
                ),
                EmissionTimeLineChart(
                  unit: vm.waterData[vm.currentSelectedCardIndex]["unit"],
                  data: EmissionTimeData.generateFakeWeaklyData().sublist(0, 3)
                ),
              ],
            )
          ],
          ),
      ),
    );
  }  
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardViewModel>(
      create: (context) => DashboardViewModel(),
      child: HomePageBaseView(
        body: DashboardPadding.object(
          child: DashboardFrame(
            padding: const EdgeInsets.all(0.0),
            child: DashboardPadding.medium(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(flex: 1, child: getFactoryInfoFrame()),
                    // DashboardDivider.small(),
                    DashboardSizedBox.large(),
                    Consumer<DashboardViewModel>(
                      builder: (context, vm, child){
                        if(vm.currentSelectedCategoryIndex == 0){
                          return Expanded(
                            flex: 14,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(flex: 4, child: qualityIndexFrame()),
                                Expanded(flex: 3, child: qualityIndexFrame2()),
                                Expanded(flex: 8, child: splineChartsFrame()),
                              ],
                            ),
                          );
                        }else{
                          return Expanded(
                            flex: 14,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                
                                 Expanded(flex: 4, child: waterQualityIndexFrame()),
                                Expanded(flex: 3, child: waterQualityIndexFrame2()),
                                Expanded(flex: 8, child: waterSplineChartsFrame()),
                              ],
                            ),
                          );
                        }
                      }
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}
