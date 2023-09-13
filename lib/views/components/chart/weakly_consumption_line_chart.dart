import 'package:flutter/material.dart';
import 'package:web_dashboard/models/search/consumption_search_node.dart';
import 'package:web_dashboard/models/search/search_node.dart';
import 'package:web_dashboard/views/theme/color.dart';
import 'package:web_dashboard/views/theme/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeeklyConsumptionLineChart<ModelType extends SearchTreeNode> extends StatelessWidget{
  final List<ModelType> data;
  final List<ModelType>? cmpLine;
  const WeeklyConsumptionLineChart({super.key, required this.data, this.cmpLine});

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
            xValueMapper: (ModelType data, index) => DashBoardFormat.iO8dateTime((data as ConsumptionSearchNode).dateTime.toIso8601String()),
            yValueMapper: (ModelType data, _) => (data as ConsumptionSearchNode).dayConsumption,
            name: '近7天用電量趨勢',
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
          if(cmpLine != null) 
            AreaSeries<ModelType, String>(
              dataSource: cmpLine!,
              xValueMapper: (ModelType d, index) => DashBoardFormat.iO8dateTime((data[index] as ConsumptionSearchNode).dateTime.toIso8601String()),
              yValueMapper: (ModelType data, _) => (data as ConsumptionSearchNode).dayConsumption,
              name: '上7天用電量趨勢',
              xAxisName: '時間軸',
              yAxisName: '用電量',
              // splineType: SplineType.monotonic,
              enableTooltip: true,
              // width: 2,
              color: Colors.grey.withOpacity(0.3),
              // color: Theme.of(context).colorScheme.primary,
              // Enable data label
              // dataLabelSettings: const DataLabelSettings(isVisible: true)
            )
        ],
      );
  }

}