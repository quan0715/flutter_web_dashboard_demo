import 'package:flutter/material.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class ConsumptionDetailGridView extends StatelessWidget {
  final String label;
  final int dayConsumption;
  final int monthConsumption;
  final double averageMonthConsumptionPerMonth;

  const ConsumptionDetailGridView({
    super.key, 
    this.label = "",
    this.dayConsumption = 0,
    this.monthConsumption = 0,
    this.averageMonthConsumptionPerMonth = 0,
  });
  // final SumOfElectricityConsumptionDataModel dataSource;

  Widget getTitleWithContent(BuildContext context, String title, String value, {bool isError = false}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: DashboardText.labelMedium(context),),
        Text(value, style: DashboardText.labelLarge(context).copyWith(
          color: isError? DashboardColor.incorrect : DashboardColor.correct
        )),
      ],
    );
  }
  Widget valueBlock(BuildContext context, String title, String value, {bool isError = false}){
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: DashboardText.titleMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: DashboardColor.secondary(context),
              )),
               Text(title, style: DashboardText.labelMedium(context).copyWith(
                color: DashboardColor.onSurface(context).withOpacity(0.5)
               ),),
          ],),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DashboardPadding.small(child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              avatar: Icon(Icons.circle, color: DashboardColor.primary(context), size: 12,),
              label: Text(label),
              side: BorderSide.none,
            ),
            // Spacer(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: valueBlock(context, "日累積用電", DashBoardFormat.number(dayConsumption), )),
                  Expanded(child: valueBlock(context, "月累積用電", DashBoardFormat.number(monthConsumption.toInt()))),
                  Expanded(child: valueBlock(context, "月平均小時用電", DashBoardFormat.number(averageMonthConsumptionPerMonth.toInt()))),
                ],
              ),
            ),
            // Spacer(),
        ],)
      ),
    );
    // return Card(
    //   child: DashboardPadding.small(
    //     child: Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(dataSource.groupLabel, style: DashboardText.titleMedium(context)),
    //                 // Text(dataSource.deviceData!.building!, style: DashboardText.titleSmall(context).copyWith(
    //                 //   color: DashboardColor.secondary(context),
    //                 // )),
    //                 // Text(dataSource.loc!, style: DashboardText.titleSmall(context).copyWith(
    //                 //   color: DashboardColor.secondary(context),
    //                 // )),
    //               ],
    //             ),
    //       ]),
    //         const Spacer(),
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: [
    //             getTitleWithContent(context, "本日用電", DashBoardFormat.number(dataSource.dayConsumption!)),
    //             getTitleWithContent(context, "本月累積用電", DashBoardFormat.number(dataSource.monthConsumption!.toInt())),
    //             getTitleWithContent(context, "本月平均每小時用電", DashBoardFormat.number(dataSource.averageMonthConsumptionPerMonth!.toInt())),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}