import 'package:flutter/material.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/views/theme/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardTimeLineChart<ModelType extends SearchTreeNode> extends StatelessWidget{
  final List<ModelType> data;
  final List<ModelType>? cmpLine;
  final String? Function(ModelType data, int index) xValueMapper;
  final num? Function(ModelType data, int index) yValueMapper;
  final String chartTitle;
  final String chartNumericUnit; 
  final String mainLineLabel;
  final String comparedLineLabel;
  final String numericAxisLabel;
  final String timeLineLabel;
  final Color? mainLineColor;
  final Color? comparedAreaColor;
  const DashboardTimeLineChart({
    super.key, 
    required this.data, 
    required this.xValueMapper,
    required this.yValueMapper,
    this.chartTitle = "",
    this.chartNumericUnit = "",
    this.mainLineLabel = "主數據", 
    this.comparedLineLabel = "比較數據",
    this.numericAxisLabel = "數值軸",
    this.timeLineLabel = "時間軸", 
    this.mainLineColor,
    this.comparedAreaColor,
    this.cmpLine
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        borderWidth: 2,
        legend: const Legend(
          shouldAlwaysShowScrollbar: false,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom, 
          isVisible: true,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(
          name: timeLineLabel,
          majorGridLines: const MajorGridLines(width: 1),
          labelPlacement: LabelPlacement.onTicks,
          // labelIntersectAction: AxisLabelIntersectAction.multipleRows
        ),
        primaryYAxis: NumericAxis(
            minimum: 0,
            name: numericAxisLabel,
            axisLine: const AxisLine(width: 1),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelFormat: '{value} $chartNumericUnit',
            majorTickLines: const MajorTickLines(size: 1)),
        series: <XyDataSeries<ModelType, String>>[
          SplineSeries<ModelType, String>(
            dataSource: data,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            name: mainLineLabel,
            xAxisName: timeLineLabel,
            yAxisName: numericAxisLabel,
            width: 2,
            color: mainLineColor ?? DashboardColor.primary(context),
            enableTooltip: true,
          ),
          if(cmpLine != null) 
            AreaSeries<ModelType, String>(
              dataSource: cmpLine!,
              xValueMapper: (data, index) => xValueMapper(this.data[index], index),
              yValueMapper: yValueMapper,
              name: comparedLineLabel,
              xAxisName: timeLineLabel,
              yAxisName: numericAxisLabel,
              enableTooltip: true,
              color: comparedAreaColor ?? Colors.grey.withOpacity(0.3),
            )
        ],
      );
  }
}