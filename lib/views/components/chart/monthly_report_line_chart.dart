import 'package:flutter/material.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/views/theme/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyReportLineChart<ModelType extends SearchTreeNode> extends StatelessWidget{
  final List<ModelType> data;
  final List<ModelType> cmpLine;
  final String? Function(ModelType data, int index) xValueMapper;
  final num? Function(ModelType data, int index) yValueMapper;
  // : (ModelType data, index) => DashBoardFormat.iO8dateTime((data as ConsumptionSearchNode).dateTime.toIso8601String()),
  // yValueMapper: (ModelType data, _) => (data as ConsumptionSearchNode).dayConsumption,
  const MonthlyReportLineChart({
    super.key, 
    required this.data,
    required this.cmpLine,
    required this.xValueMapper,
    required this.yValueMapper,
  });

  @override
  Widget build(BuildContext context) {
    // data.forEach((element) => debugPrint("${element.time} ${element.power}"));
    return SfCartesianChart(
        borderWidth: 2,
        // title: ChartTitle(text: '即時用電量趨勢圖(最近8小時)'),
        legend: const Legend(
          shouldAlwaysShowScrollbar: false,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom, 
          isVisible: true,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(
          name: "時間",
          majorGridLines: const MajorGridLines(width: 1),
          labelPlacement: LabelPlacement.onTicks,
          // labelIntersectAction: AxisLabelIntersectAction.multipleRows
        ),
        primaryYAxis: NumericAxis(
            minimum: 0,
            name: "用電",
            // maximum: 1000000,
            axisLine: const AxisLine(width: 1),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelFormat: '{value} KW',
            majorTickLines: const MajorTickLines(size: 1)),
        series: <XyDataSeries<ModelType, String>>[
          SplineSeries<ModelType, String>(
            dataSource: data,
            xValueMapper: xValueMapper,
            // DashBoardFormat.iO8dateTime((data as ConsumptionSearchNode).dateTime.toIso8601String()),
            yValueMapper: yValueMapper,
            // (data as ConsumptionSearchNode).dayConsumption,
            name: '2023 7月用電量趨勢',
            xAxisName: '時間軸',
            yAxisName: '用電量',
            width: 2,
            // dashArray: <double>[5, 5],
            // borderDrawMode: BorderDrawMode.top,
            color: DashboardColor.primary(context),
            
            
            // splineType: SplineType.monotonic,
            enableTooltip: true,
            // Enable data label
            // dataLabelSettings: const DataLabelSettings(isVisible: true)
          ),
          ColumnSeries<ModelType, String>(
            name: "2022 7月用電量趨勢",
            color: Colors.grey.withOpacity(0.3),
            dataSource: cmpLine,
            borderRadius: BorderRadius.circular(5.0),
            xValueMapper: xValueMapper,
            // DashBoardFormat.iO8dateTime((data as ConsumptionSearchNode).dateTime.toIso8601String()),
            yValueMapper: yValueMapper,
            // (data as ConsumptionSearchNode).dayConsumption,
            dataLabelSettings: const DataLabelSettings(
                isVisible: false, textStyle: TextStyle(fontSize: 10)),
          )
        ],
      );
  }

}