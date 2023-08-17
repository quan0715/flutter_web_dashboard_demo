import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:web_dashboard/models/repo/sum_consumption_repo_model.dart';
import 'package:web_dashboard/views/theme/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SumOfConsumptionPieChart extends StatelessWidget {
  const SumOfConsumptionPieChart({
    super.key,
    required this.dataSource,
  });
  final List<PieChartProportion<SumOfElectricityConsumptionDataModel>> dataSource;


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
        format: 'point.x : point.y kWH',
      ),
      
      palette: const GoogleGrad().colors,
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
              Text(DashBoardFormat.number(amount), style: TextStyle(
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
      series: <DoughnutSeries<PieChartProportion<SumOfElectricityConsumptionDataModel>, String>>[
        DoughnutSeries<PieChartProportion<SumOfElectricityConsumptionDataModel>, String>(
            radius: '80%',
            innerRadius: '70%',
            explode: true,
            explodeOffset: '10%',
            dataSource: dataSource,
            xValueMapper: (PieChartProportion<SumOfElectricityConsumptionDataModel> data, _) => data.model.groupLabel,
            yValueMapper: (PieChartProportion<SumOfElectricityConsumptionDataModel> data, _) => data.amount,
            dataLabelMapper: (PieChartProportion data, _)
              => "${data.model!.groupLabel}\n${data.proportion.toStringAsFixed(1)}%",
            
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