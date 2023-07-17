import 'package:flutter/material.dart';
import 'package:prologium_project_demo/models/ammeter_model.dart';
import 'package:prologium_project_demo/views/common/color.dart';
import 'package:prologium_project_demo/views/common/format.dart';
import 'package:prologium_project_demo/views/common/padding.dart';
class InfoCardGridView extends StatelessWidget {
  const InfoCardGridView({
    super.key, 
    required this.ammeter, 
    required this.textTitleStyle,
    required this.textValueStyle,
    required this.textHeadLineStyle,
    required this.isSelected,
  });
  final AmmeterModel ammeter;
  final TextStyle textTitleStyle;
  final TextStyle textValueStyle;
  final TextStyle textHeadLineStyle;
  final bool isSelected;
  factory InfoCardGridView.factory(BuildContext context, AmmeterModel ammeter, bool isSelected) {
    return InfoCardGridView(
      ammeter: ammeter,
      textTitleStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
      textValueStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      textHeadLineStyle : Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      isSelected: isSelected,
    );
  }
  factory InfoCardGridView.workspace(BuildContext context, AmmeterModel ammeter) {
    return InfoCardGridView(
      ammeter: ammeter,
      textTitleStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
      textValueStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold,),
      textHeadLineStyle : Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
      isSelected: false,
    );
  }

  Widget getTitleWithContent(String title, String value, {bool isError = false}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: textTitleStyle,),
        Text(value, style: textValueStyle.copyWith(
          color: isError? DashboardColor.incorrect : DashboardColor.correct
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 12 : 1,
      shape: isSelected ? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2, 
        )
      ) : null,
      child: DashboardPadding.small(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ammeter.name, style: textHeadLineStyle.copyWith(
                  fontWeight: FontWeight.bold,
                )),
                Text(ammeter.ammeterId, style: textHeadLineStyle.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  //fontWeight: FontWeight.bold,
                )),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                ammeter.location.isNotEmpty
                ? RawChip(
                  avatar: const Icon(Icons.location_city_outlined),
                  visualDensity: VisualDensity.compact,
                  label: Text(ammeter.location),
                  labelStyle: textTitleStyle,
                  side: BorderSide.none,
                ) : Container(),
                const SizedBox(height: 8,),
                ammeter.label.isNotEmpty
                ? RawChip(
                  avatar: Text(ammeter.label),
                  visualDensity: VisualDensity.compact,
                  label: Text(ammeter.label),
                  labelStyle: textTitleStyle,
                  side: BorderSide.none,
                ) : Container()
                ],
                ),
          ]),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                getTitleWithContent(
                  "本日用電", DashBoardFormat.number(ammeter.ammeterData.currentElectricityFlow),
                  isError: ammeter.ammeterData.currentElectricityFlowError()
                ),
                getTitleWithContent("本月用電", DashBoardFormat.number(ammeter.ammeterData.monthlyAccumulatedElectricityFlow),
                 isError: ammeter.ammeterData.monthElectricityFlowError()),
                getTitleWithContent("本月平均每小時用電", DashBoardFormat.number(ammeter.ammeterData.monthlyAccumulatedElectricityFlowPerHour), 
                  isError: ammeter.ammeterData.monthElectricityFlowPerHourError()),
              ],
            )
          ],
        ),
      ),
    );
  }
}