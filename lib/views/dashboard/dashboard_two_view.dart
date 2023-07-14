import 'package:flutter/material.dart';
import 'package:prologium_project_demo/views/home_page_base.dart';

class DashBoardTwoView extends StatefulWidget {
  const DashBoardTwoView({super.key});

  @override
  State<DashBoardTwoView> createState() => _DashBoardTwoViewState();
}

class _DashBoardTwoViewState extends State<DashBoardTwoView> {
  // Widget chartCardView(BuildContext context){
  //   return Consumer<ElectricityDataDashboardViewModel>(
  //     builder: (context, vm, child) => Padding(
  //       padding: const EdgeInsets.all(10.0),
  //       child: Card(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //               child: getHeadlineSection(vm.currentSelectedFactoryData.factoryName),
  //             ),
  //             const Divider(height: 5, thickness: 2, indent: 20, endIndent: 20,),
  //             Row(
  //               mainAxisSize: MainAxisSize.max,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Expanded(
  //                   flex: 3,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child:  Column(
  //                       children: [
  //                         getQuoteSection("即時用電量趨勢圖(最近8小時)"), 
  //                         ElectricityTimeLineChart(data: vm.lineChartData),
  //                       ],
  //                     )
  //                   )),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             getQuoteSection("實際用電數據"),
  //                             const Spacer(),
  //                             const RawChip(
  //                               visualDensity: VisualDensity.compact,
  //                               avatar: CircleAvatar(backgroundColor: Colors.green, radius: 6,),
  //                               label: Text("正常"),
  //                               side: BorderSide.none,
  //                             ),
  //                             const Divider(indent: 5, endIndent: 5,),
  //                             RawChip(
  //                               visualDensity: VisualDensity.compact,
  //                               avatar: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.error, radius: 6,),
  //                               label: const Text("異常"),
  //                               side: BorderSide.none,
  //                             ),
  //                           ],
  //                         ),
  //                         InfoCard(title: "今日用電總量", value: vm.currentSelectedFactoryData.todayElectricityFlow, unit: "kWH"),
  //                         InfoCard(title: "本月用電", value: vm.currentSelectedFactoryData.monthElectricityFlow, unit: "kWH"),
  //                         InfoCard(
  //                           title: "本月平均每小時用電",
  //                           value: vm.currentSelectedFactoryData.monthElectricityFlowPerHour,
  //                           unit: "kWH",
  //                           errorReport: (value) => value > vm.currentSelectedFactoryData.lastMonthElectricityFlowPerHour,
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
  //                   flex: 3,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child:  Column(
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Column(
  //                               children: [
  //                                 getQuoteSection("全場總電量使用分佈"), 
  //                                 ElectricityDistributionPieChartPieChart(
  //                                   chartData: ElectricityAmountProportion.generateFakeData(),
  //                                 )
  //                               ],
  //                             ),
  //                             Column(
  //                               children: [
  //                                 getQuoteSection("廠務總電量使用分佈"), 
  //                                 ElectricityDistributionPieChartPieChart(
  //                                   chartData: ElectricityAmountProportion.generateFakeData1(),
  //                                 )
  //                               ],
  //                             ),
  //                             Column(
  //                               children: [
  //                                 getQuoteSection("產線總電量使用分佈"), 
  //                                 ElectricityDistributionPieChartPieChart(
  //                                   chartData: ElectricityAmountProportion.generateFakeData2(),
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     )
  //                   )),
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
  //                             const RawChip(
  //                               visualDensity: VisualDensity.compact,
  //                               avatar: CircleAvatar(backgroundColor: Colors.green, radius: 6,),
  //                               label: Text("正常"),
  //                               side: BorderSide.none,
  //                             ),
  //                             const Divider(indent: 5, endIndent: 5,),
  //                             RawChip(
  //                               visualDensity: VisualDensity.compact,
  //                               avatar: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.error, radius: 6,),
  //                               label: const Text("異常"),
  //                               side: BorderSide.none,
  //                             ),
  //                           ],
  //                         ),
  //                         InfoCard(
  //                           title: "產線1",
  //                           value: vm.currentSelectedFactoryData.monthElectricityFlowPerHour,
  //                           unit: "kWH",
  //                           errorReport: (value) => value > vm.currentSelectedFactoryData.lastMonthElectricityFlowPerHour,
  //                         ),InfoCard(
  //                           title: "產線2",
  //                           value: vm.currentSelectedFactoryData.monthElectricityFlowPerHour,
  //                           unit: "kWH",
  //                           errorReport: (value) => value > vm.currentSelectedFactoryData.lastMonthElectricityFlowPerHour,
  //                         ),InfoCard(
  //                           title: "產線3",
  //                           value: vm.currentSelectedFactoryData.monthElectricityFlowPerHour,
  //                           unit: "kWH",
  //                           errorReport: (value) => value > vm.currentSelectedFactoryData.lastMonthElectricityFlowPerHour,
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

  // Widget getHeadlineSection(String text){
  //   return Text(text, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),);
  // }

  // Widget getQuoteSection(String text){
  //   return Padding(padding: const EdgeInsets.all(10.0),
  //     child: Row( children: [
  //         Container( width: 4, height: 20,
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).colorScheme.primary,
  //             borderRadius: BorderRadius.circular(5),
  //           )
  //         ),
  //         const SizedBox(width: 10,),
  //         Text(text,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return const HomePageBaseView(
      body: Center(
        child: Text("施工中"),
      ),
      // body: ChangeNotifierProvider<ElectricityDataDashboardViewModel>(
      //   create: (context) => ElectricityDataDashboardViewModel(),
      //   child: Consumer<ElectricityDataDashboardViewModel>(
      //     builder: (context, electricityDataDashboardViewModel, child) => SingleChildScrollView(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.only(right: 20),
      //               child: Row(
      //                 // crossAxisAlignment: CrossAxisAlignment.end,
      //                 children: [
      //                   getHeadlineSection("電表總覽"),
      //                   // const Spacer(flex: 10,),
      //                   const SizedBox(width: 10,),
      //                   const Spacer(),
      //                   Checkbox(
      //                     value: electricityDataDashboardViewModel.onlyShowingErrorCard,
      //                     onChanged: (value){
      //                       electricityDataDashboardViewModel.onlyShowingErrorCard = value!;
      //                     }
      //                   ), 
      //                   const Text("只顯示異常電表", style: TextStyle(fontWeight: FontWeight.bold),), 
      //                   const SizedBox(width: 10,),
      //                   ElevatedButton.icon(
      //                     style: ElevatedButton.styleFrom(
      //                       visualDensity: VisualDensity.compact,
      //                       backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      //                       foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(5.0),
      //                       ),
      //                     ),
      //                     onPressed: (){}, label: const Text("異常問題紀錄"),
      //                     icon: const Icon(Icons.error),)
      //                 ],
      //               ),
      //             ),
      //             getQuoteSection("廠區"),
      //             GridView.builder(
      //               physics: const NeverScrollableScrollPhysics(),
      //               // padding: const EdgeInsets.all(10.0),
      //               shrinkWrap: true,
      //               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //                 maxCrossAxisExtent: 550,
      //                 mainAxisSpacing: 15,
      //                 crossAxisSpacing: 15,
      //                 childAspectRatio: 1.9
      //               ),
      //               itemCount: electricityDataDashboardViewModel.factoryData.length,
      //               itemBuilder: (context, index) {
      //                 return MaterialButton(
      //                   padding: EdgeInsets.zero,
      //                   onPressed: (){
      //                     electricityDataDashboardViewModel.currentSelectedFactoryIndex = index;
      //                   },
      //                   child: InfoCardGridView.factory(context, electricityDataDashboardViewModel.factoryData[index], electricityDataDashboardViewModel.currentSelectedFactoryIndex == index),
      //                 );
      //               },
      //             ),
      //             getQuoteSection("產線"),
      //             GridView.builder(
      //               physics: const NeverScrollableScrollPhysics(),
      //               shrinkWrap: true,
      //               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //                 maxCrossAxisExtent: 450,
      //                 mainAxisSpacing: 6,
      //                 crossAxisSpacing: 8,
      //                 childAspectRatio: 1.9
      //               ),
      //               itemCount: electricityDataDashboardViewModel.workspaceData.length,
      //               itemBuilder: (context, index) {
      //                 return InfoCardGridView.workspace(context, electricityDataDashboardViewModel.workspaceData[index]);
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      );
  }
}