import 'package:flutter/material.dart';
import 'package:web_dashboard/views/components/widget/dashboard_widget.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class ConsumptionDetailGridView extends StatelessWidget {
  final String label;
  final List<ValueBlock> valueBlocks;
  final Color? color;

  const ConsumptionDetailGridView({
    super.key, 
    this.label = "",
    this.color,
    this.valueBlocks = const [],
  });
  // final SumOfElectricityConsumptionDataModel dataSource;
  @override
  Widget build(BuildContext context) {
    return DashboardFrameCard(
      padding: EdgeInsets.zero,
      child: DashboardPadding.small(child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              avatar: Icon(Icons.circle, color: color ?? DashboardColor.primary(context), size: 12,),
              label: Text(label),
              side: BorderSide.none,
            ),
            // Spacer(),
            Expanded(
              child: GridView.builder(
                itemCount: valueBlocks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, index) => valueBlocks[index],
              )
            ),
            // Spacer(),
        ],)
      ),
    );
  }
}

class ValueBlock extends StatelessWidget{
  final String blockTitle;
  final String blockUnit;
  final num blockValue;
  const ValueBlock({super.key, this.blockTitle = "", this.blockUnit = "", this.blockValue = 0});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(blockTitle, style: DashboardText.labelMedium(context).copyWith(
              color: DashboardColor.onSurface(context).withOpacity(0.5)
              ),),
              Text(DashBoardFormat.number(blockValue.toInt()), style: DashboardText.titleMedium(context).copyWith(
                color: DashboardColor.secondary(context),
              )),
              Text(blockUnit, style: DashboardText.labelMedium(context).copyWith(
              color: DashboardColor.onSurface(context).withOpacity(0.5)
              ),),
          ],),
        ),
      ),
    );
  }
}