import 'dart:math';
import 'package:prologium_project_demo/models/emmission_time_data.dart';

class ElectricityFlowData {
  static int countCycle = 8; // hour

  List<EmissionTimeData> weaklyAccumulatedElectricityFlow =
      []; // 週累積電量 (最近 7 天)
  List<EmissionTimeData> lastWeaklyAccumulatedElectricityFlow =
      []; // 週累積電量 (最近 7 天)
  int monthlyAccumulatedElectricityFlow = 0; // 月累積電量 (最近 30 天)
  int lastMonthlyAccumulatedElectricityFlow = 0;

  ElectricityFlowData({
    required this.weaklyAccumulatedElectricityFlow,
    required this.lastWeaklyAccumulatedElectricityFlow,
    required this.monthlyAccumulatedElectricityFlow,
    required this.lastMonthlyAccumulatedElectricityFlow,
  });

  factory ElectricityFlowData.fakeData() {
    int _date = DateTime.now().day;
    List<EmissionTimeData> weaklyAccumulatedElectricityFlow =
        EmissionTimeData.generateThisWeakData();
    List<EmissionTimeData> lastWeaklyAccumulatedElectricityFlow =
        EmissionTimeData.generateFakeWeaklyData();
    int monthlyAccumulatedElectricityFlow =
        (lastWeaklyAccumulatedElectricityFlow
                    .map((e) => e.amount)
                    .reduce((value, element) => value + element)
                    .toInt() /
                7 *
                _date *
                (1 + Random().nextDouble() * Random().nextDouble()))
            .toInt();
    var w1 = EmissionTimeData.generateFakeWeaklyData();
    int lastMonthlyAccumulatedElectricityFlow = (w1
                .map((e) => e.amount)
                .reduce((value, element) => value + element)
                .toInt() *
            4 *
            _date *
            (1 + Random().nextDouble() * Random().nextDouble()))
        .toInt();

    return ElectricityFlowData(
      weaklyAccumulatedElectricityFlow: weaklyAccumulatedElectricityFlow,
      lastWeaklyAccumulatedElectricityFlow:
          lastWeaklyAccumulatedElectricityFlow,
      monthlyAccumulatedElectricityFlow: monthlyAccumulatedElectricityFlow,
      lastMonthlyAccumulatedElectricityFlow:
          lastMonthlyAccumulatedElectricityFlow,
    );
  }

  int get monthlyAccumulatedElectricityFlowPerHour =>
      monthlyAccumulatedElectricityFlow ~/ DateTime.now().day ~/ 24;

  int get lastMonthlyAccumulatedElectricityFlowPerHour =>
      lastMonthlyAccumulatedElectricityFlow ~/ DateTime.now().day ~/ 24;

  int get currentElectricityFlow =>
      weaklyAccumulatedElectricityFlow.isNotEmpty
          ? weaklyAccumulatedElectricityFlow.last.amount.toInt()
          : 0;
      // weaklyAccumulatedElectricityFlow.last.power.toInt();

  bool currentElectricityFlowError() =>
      currentElectricityFlow >
      lastWeaklyAccumulatedElectricityFlow.last.amount.toInt();
  bool monthElectricityFlowPerHourError() =>
      monthlyAccumulatedElectricityFlowPerHour >
      lastMonthlyAccumulatedElectricityFlowPerHour;
  bool monthElectricityFlowError() =>
      monthlyAccumulatedElectricityFlow > lastMonthlyAccumulatedElectricityFlow;

  bool isError() =>
      monthElectricityFlowPerHourError() ||
      monthElectricityFlowError() ||
      currentElectricityFlowError();
}
