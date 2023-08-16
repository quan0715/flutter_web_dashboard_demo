import 'package:flutter/material.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final int value;
  final String unit;
  final bool Function(int value)? errorReport;
  const InfoCard(
      {super.key,
      required this.title,
      required this.value,
      required this.unit,
      this.errorReport});


  @override
  Widget build(BuildContext context) {
    var error = errorReport != null && errorReport!(value);
    final TextStyle titleStyle = TextStyle(
      color: DashboardColor.secondary(context).withOpacity(0.7),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final TextStyle valueStyle = TextStyle(
      color: DashboardColor.secondary(context),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    final TextStyle unitStyle = TextStyle(
      color: DashboardColor.secondary(context).withOpacity(0.7),
      fontSize: 14,
      fontStyle: FontStyle.italic,
      // fontWeight: FontWeight.bold,
    );
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        // side: BorderSide(
        //   color: (error ? DashboardColor.incorrect : DashboardColor.correct).withOpacity(0.7),
        //   // width: 1,
        // )
      ), 
      child: DashboardPadding.medium(
        child: Row(
          mainAxisSize: MainAxisSize.min ,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: titleStyle,),
            const Spacer(), 
            DashboardSizedBox.medium(),
            Text(DashBoardFormat.number(value), style: valueStyle,),
            DashboardSizedBox.small(),
            Text(unit, style: unitStyle),
          ],
        ),
      ),
    );
  }
}
