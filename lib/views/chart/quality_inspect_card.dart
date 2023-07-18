import 'package:flutter/material.dart';
import 'package:prologium_project_demo/views/chart/components/frame_quote.dart';
import 'package:prologium_project_demo/views/common/color.dart';
import 'package:prologium_project_demo/views/common/padding.dart';
import 'package:prologium_project_demo/views/common/text.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class QualityInspectCard extends StatelessWidget{
  QualityInspectCard({
    super.key,
    required this.category,
    required this.detail,
    required this.label,
    required this.color,
    required this.upperBound,
    required this.lowerBound,
    required this.value,

  });
  final String category;
  final String detail;
  final String label ;
  final Color color;
  final double upperBound;
  final double lowerBound;
  final double value;
  


  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          showLabels: false,
          showTicks: false,
          radiusFactor: 0.8,
          startAngle: 125,
          endAngle: 55,
          minimum: lowerBound,
          maximum: upperBound,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: color.withOpacity(0.2),
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
                color: color,
                value: value,
                cornerStyle: CornerStyle.bothCurve,
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 20,
                animationType: AnimationType.linear
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Text(
                  value.toInt().toString(),
                  style: DashboardText.bodyLarge(context),
                )
            ),
            GaugeAnnotation(
              angle: 114,
              positionFactor: 1.0,
              widget:
                  Text(lowerBound.toInt().toString(), style: TextStyle(fontSize: 10)),
            ),
            GaugeAnnotation(
              angle: 66,
              positionFactor: 1.0,
              widget: Text(upperBound.toInt().toString(),
                  style: TextStyle(fontSize: 12)),
            ),
          ]
        ),],
        enableLoadingAnimation: true,
      );
  }

}


