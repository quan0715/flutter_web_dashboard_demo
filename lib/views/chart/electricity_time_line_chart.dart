

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:prologium_project_demo/models/electricity_time_data.dart';
import 'package:prologium_project_demo/views/common/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ElectricityTimeLineChart extends StatelessWidget{
  final List<ElectricityTimeData> data;
  final List<ElectricityTimeData>? cmpLine;
  const ElectricityTimeLineChart({super.key, required this.data, this.cmpLine});

  @override
  Widget build(BuildContext context) {
    data.forEach((element) => debugPrint("${element.time} ${element.power}"));
    return SfCartesianChart(
        borderWidth: 2,
        // title: ChartTitle(text: '即時用電量趨勢圖(最近8小時)'),
        legend: const Legend(
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
        series: <XyDataSeries<ElectricityTimeData, String>>[
          SplineAreaSeries<ElectricityTimeData, String>(
            name: '本週用電紀錄',
            dataSource: data, 
            xValueMapper: (ElectricityTimeData data, index) => DashBoardFormat.dayTimeChartLabel(data.time), 
            yValueMapper: (ElectricityTimeData data, _) => data.power.toInt(),
            isVisible: true,
            isVisibleInLegend: true,
            borderDrawMode: BorderDrawMode.all,
            // borderColor: Theme.of(context).colorScheme.secondary,
            // borderWidth: 2,
            color: Theme.of(context).colorScheme.tertiary,
            splineType: SplineType.monotonic,
            opacity: 0.6
          ),
          // SplineSeries<ElectricityTimeData, String>(
          //   dataSource: data,
          //   xValueMapper: (ElectricityTimeData data, index) => DashBoardFormat.dayTime(data.time),
          //   yValueMapper: (ElectricityTimeData data, _) =>
          //       data.power.toInt(),
          //   name: '即時用電量',
          //   xAxisName: '時間軸',
          //   yAxisName: '用電量',
          //   splineType: SplineType.monotonic,
          //   enableTooltip: true,
          //   // Enable data label
          //   // dataLabelSettings: const DataLabelSettings(isVisible: true)
          // ),
          if(cmpLine != null) 
            SplineSeries<ElectricityTimeData, String>(
              dataSource: cmpLine!,
              xValueMapper: (ElectricityTimeData data, index)
                => DashBoardFormat.dayTimeChartLabel(data.time.add(const Duration(days: 7))),
              yValueMapper: (ElectricityTimeData data, _) =>
                  data.power.toInt(),
              name: '上週用電紀錄',
              xAxisName: '時間軸',
              yAxisName: '用電量',
              splineType: SplineType.monotonic,
              enableTooltip: true,
              width: 2,
              color: Theme.of(context).colorScheme.primary,
              // Enable data label
              // dataLabelSettings: const DataLabelSettings(isVisible: true)
            )
        ],
      );
  }

}