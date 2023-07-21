import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:flutter_brand_palettes/gradients.dart';
import 'package:web_dashboard/models/electricity_amount_proportion.dart';
import 'package:web_dashboard/views/theme/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ElectricityDistributionPieChartPieChart extends StatelessWidget {
  const ElectricityDistributionPieChartPieChart({
    super.key,
    required this.chartData
  });
  final List<ElectricityAmountProportion> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y kWH',
      ),
      palette: const InstagramGrad().colors,
      annotations: [
        CircularChartAnnotation(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("總耗電量", style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),),
              Text(DashBoardFormat.number(ElectricityAmountProportion.countAmount(chartData)), style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold
              )),
              Text("kWh", style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),),
            ],
          )
        )
      ],
      series: <DoughnutSeries<ElectricityAmountProportion, String>>[
        DoughnutSeries<ElectricityAmountProportion, String>(
            radius: '80%',
            innerRadius: '70%',
            explode: true,
            explodeOffset: '10%',
            dataSource: chartData,
            xValueMapper: (ElectricityAmountProportion data, _) => data.name,
            yValueMapper: (ElectricityAmountProportion data, _) => data.amount,
            dataLabelMapper: (ElectricityAmountProportion data, _)
              => "${data.name}\n${(data.amount / ElectricityAmountProportion.countAmount(chartData) * 100).toStringAsFixed(1)}%",
            animationDuration: 500,
            dataLabelSettings: const DataLabelSettings(
              alignment: ChartAlignment.near,
              labelPosition: ChartDataLabelPosition.outside,
              isVisible: true,
              overflowMode: OverflowMode.none,
            ))
      ],
      // tooltipBehavior: _tooltip,
    );
  }
}