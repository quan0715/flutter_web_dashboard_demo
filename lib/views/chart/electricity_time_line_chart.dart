

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:prologium_project_demo/models/emmission_time_data.dart';
import 'package:prologium_project_demo/views/common/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EmissionTimeLineChart extends StatelessWidget{
  final List<EmissionTimeData>? data;
  final String unit;
  // final List<ElectricityTimeData>? cmpLine;
  const EmissionTimeLineChart({super.key, this.data, this.unit = "ppm"});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        borderWidth: 2,
        legend: const Legend(
          position: LegendPosition.left, 
          isVisible: false,
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
            name: "排放量",
            // maximum: 1000000,
            axisLine: const AxisLine(width: 1),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelFormat: '{value} $unit',
            majorTickLines: const MajorTickLines(size: 1)),
        series: <XyDataSeries<EmissionTimeData, String>>[
           SplineSeries<EmissionTimeData, String>(
            name: '用量紀錄',
            dataSource: data ?? EmissionTimeData.generateFakeWeaklyData(), 
            xValueMapper: (EmissionTimeData data, index) => DashBoardFormat.dayTimeChartLabel(data.time), 
            yValueMapper: (EmissionTimeData data, _) => data.amount.toInt(),
            isVisible: true,
            isVisibleInLegend: true,
            // borderDrawMode: BorderDrawMode.all,
            // borderColor: Theme.of(context).colorScheme.secondary,
            // borderWidth: 2,
            color: Theme.of(context).colorScheme.tertiary,
            splineType: SplineType.monotonic,
            opacity: 0.6
          ),
          SplineSeries<EmissionTimeData, String>(
            name: '用量紀錄',
            dataSource: data ?? EmissionTimeData.generateFakeWeaklyData(), 
            xValueMapper: (EmissionTimeData data, index) => DashBoardFormat.dayTimeChartLabel(data.time), 
            yValueMapper: (EmissionTimeData data, _) => 101,
            isVisible: true,
            isVisibleInLegend: true,
            color: Colors.orange,
            splineType: SplineType.monotonic,
            opacity: 0.6
          ),
          SplineSeries<EmissionTimeData, String>(
            name: '用量紀錄',
            dataSource: data ?? EmissionTimeData.generateFakeWeaklyData(), 
            xValueMapper: (EmissionTimeData data, index) => DashBoardFormat.dayTimeChartLabel(data.time), 
            yValueMapper: (EmissionTimeData data, _) => 201,
            isVisible: true,
            isVisibleInLegend: true,
            color: Colors.red,
            splineType: SplineType.monotonic,
            opacity: 0.6
          ),
          // SplineSeries(dataSource: dataSource, xValueMapper: xValueMapper, yValueMapper: yValueMapper)          
        ],
      );
  }

}