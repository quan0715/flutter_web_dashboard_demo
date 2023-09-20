import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/views/theme/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class DashboardPieChart<ModelType extends SearchTreeNode> extends StatelessWidget {
  const DashboardPieChart({
    super.key,
    this.chartTitle = "",
    this.chartAmountUnitLabel = "",
    required this.dataSource,
  });
  final String chartTitle;
  final String chartAmountUnitLabel;
  final List<PieChartProportion> dataSource;

  @override
  Widget build(BuildContext context) {
    int amount = 0;
    for (var item in dataSource) {
      amount += item.amount;
    }
    return SfCircularChart(
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.scroll,
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y ${this.chartAmountUnitLabel}',
      ),
      
      palette: const GoogleGrad().colors,
      annotations: [
        CircularChartAnnotation(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(chartTitle, style: DashboardText.labelLarge(context).copyWith(color: DashboardColor.secondary(context))),
              Text(DashBoardFormat.number(amount), style: DashboardText.titleLarge(context)), 
              Text(this.chartAmountUnitLabel, style: DashboardText.labelLarge(context).copyWith(color: DashboardColor.secondary(context))),
            ],
          )
        )
      ],
      series: <DoughnutSeries<PieChartProportion, String>>[
        DoughnutSeries<PieChartProportion, String>(
            radius: '80%',
            innerRadius: '70%',
            explode: true,
            explodeOffset: '10%',
            dataSource: dataSource,
            xValueMapper: (PieChartProportion data, _) => data.index,
            yValueMapper: (PieChartProportion data, _) => data.amount,
            dataLabelMapper: (PieChartProportion data, _)
              => "${data.index}\n${data.proportion.toStringAsFixed(1)}%",
            animationDuration: 400,
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