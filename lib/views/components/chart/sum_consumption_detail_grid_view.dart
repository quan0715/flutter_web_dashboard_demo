import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class SumOfConsumptionDetailGridView extends StatelessWidget {
  const SumOfConsumptionDetailGridView({
    super.key, 
    required this.dataSource, 
  });
  final SumOfElectricityConsumptionDataModel dataSource;

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
              Text(value, style: DashboardText.titleLarge(context).copyWith(
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
              label: Text(dataSource.groupLabel),
              side: BorderSide.none,
            ),
            // Spacer(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: valueBlock(context, "日累積用電", DashBoardFormat.number(dataSource.dayConsumption!), isError: dataSource.dayConsumption == 0)),
                  Expanded(child: valueBlock(context, "月累積用電", DashBoardFormat.number(dataSource.monthConsumption!.toInt()), isError: dataSource.monthConsumption == 0)),
                  Expanded(child: valueBlock(context, "月平均小時用電", DashBoardFormat.number(dataSource.averageMonthConsumptionPerMonth!.toInt()), isError: dataSource.averageMonthConsumptionPerMonth == 0)),
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