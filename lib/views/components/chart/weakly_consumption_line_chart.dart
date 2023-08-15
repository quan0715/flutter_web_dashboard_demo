import 'package:flutter/material.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/theme/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeeklyConsumptionLineChart extends StatelessWidget{
  final List<SumOfElectricityConsumptionDataModel> data;
  final List<SumOfElectricityConsumptionDataModel>? cmpLine;
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
        series: <XyDataSeries<SumOfElectricityConsumptionDataModel, String>>[
          SplineSeries<SumOfElectricityConsumptionDataModel, String>(
            dataSource: data,
            xValueMapper: (SumOfElectricityConsumptionDataModel data, index) => data.groupLabel,
            yValueMapper: (SumOfElectricityConsumptionDataModel data, _) => data.dayConsumption,
            name: '近7天用電量趨勢',
            xAxisName: '時間軸',
            yAxisName: '用電量',
            splineType: SplineType.monotonic,
            enableTooltip: true,
            // Enable data label
            // dataLabelSettings: const DataLabelSettings(isVisible: true)
          ),
          if(cmpLine != null) 
            SplineSeries<SumOfElectricityConsumptionDataModel, String>(
              dataSource: cmpLine!,
              xValueMapper: (SumOfElectricityConsumptionDataModel d, index)
                => data[index].groupLabel, // [index]
              yValueMapper: (SumOfElectricityConsumptionDataModel data, _) => data.dayConsumption,
              name: '上7天用電量趨勢',
              xAxisName: '時間軸',
              yAxisName: '用電量',
              splineType: SplineType.monotonic,
              enableTooltip: true,
              width: 2,
              // color: Theme.of(context).colorScheme.primary,
              // Enable data label
              // dataLabelSettings: const DataLabelSettings(isVisible: true)
            )
        ],
      );
  }

}