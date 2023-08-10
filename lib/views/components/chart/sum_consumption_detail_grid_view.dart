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

  @override
  Widget build(BuildContext context) {
    return Card(
      // clipBehavior: Clip.hardEdge,
      // elevation: isSelected ? 12 : 1,
      // shape: isSelected ? RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      //   side: BorderSide(
      //     color: Theme.of(context).colorScheme.secondary,
      //     width: 2, 
      //   )
      // ) : null,
      child: DashboardPadding.small(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dataSource.deviceData!.assetType!, style: DashboardText.titleMedium(context)),
                    Text(dataSource.deviceData!.building!, style: DashboardText.titleSmall(context).copyWith(
                      color: DashboardColor.secondary(context),
                    )),
                    // Text(dataSource.loc!, style: DashboardText.titleSmall(context).copyWith(
                    //   color: DashboardColor.secondary(context),
                    // )),
                  ],
                ),
                //DashboardSizedBox.large(),
                // DashboardSizedBox.large(),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                // ammeter.location.isNotEmpty
                // ? RawChip(
                //   avatar: const Icon(Icons.location_city_outlined),
                //   visualDensity: VisualDensity.compact,
                //   label: Text(ammeter.location),
                //   labelStyle: textTitleStyle,
                //   side: BorderSide.none,
                // ) : Container(),
                // DashboardSizedBox.small(),
                // ammeter.label.isNotEmpty
                // ? RawChip(
                //   avatar: Text(ammeter.label),
                //   visualDensity: VisualDensity.compact,
                //   label: Text(ammeter.label),
                //   labelStyle: textTitleStyle,
                //   side: BorderSide.none,
                // ) : Container()
                //],
                //),
          ]),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                getTitleWithContent(context, "本日用電", DashBoardFormat.number(dataSource.dayConsumption!)),
                getTitleWithContent(context, "本月累積用電", DashBoardFormat.number(dataSource.monthConsumption!.toInt())),
                getTitleWithContent(context, "本月平均每小時用電", DashBoardFormat.number(dataSource.averageMonthConsumptionPerMonth!.toInt())),
              ],
            )
          ],
        ),
      ),
    );
  }
}