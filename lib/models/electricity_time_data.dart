import 'dart:math';

import 'package:flutter/material.dart';

class ElectricityTimeData{
  final DateTime time;
  final double power;

  ElectricityTimeData({required this.time, required this.power});

  static List<ElectricityTimeData> generateFakeWeaklyData() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    int difference = 1 - weekday;
    DateTime thisMonday = now.add(Duration(days: difference));
    thisMonday = DateTime(thisMonday.year, thisMonday.month, thisMonday.day);
    DateTime lastMonday = thisMonday.subtract(const Duration(days: 7));
    DateTime currentTime = lastMonday;
    return generateFakeData(currentTime);
  }

  static List<ElectricityTimeData> generateFakeData(DateTime startTime,{int monitoringDate = 7,int monitoringCycleTime = 8, int initPower = 2500}){
    DateTime currentTime = startTime;
    double previousPower = initPower.toDouble(); // 初始用電量
    List<ElectricityTimeData> data = [];
    int index = 0;
    while (currentTime.isBefore(DateTime.now()) && index < (monitoringDate * 24) ~/ monitoringCycleTime) {
      double fluctuation = Random().nextDouble() * Random().nextDouble() * Random().nextDouble() * 1000;
      if (index % 3 == 0) { // 高峰时段
        fluctuation += Random().nextDouble() * 1000;
      } else if (index % 5 == 0) { // 低峰时段
        fluctuation -= Random().nextDouble() * 2000;
      }
      double power = previousPower + fluctuation;
        
      // 最小用電量 0
      if (power < 0) {
        power = 0;
      }
      // 更新前一时间点的用电量
      previousPower = power;

      data.add(ElectricityTimeData(time: currentTime, power: power));
      currentTime = currentTime.add(Duration(hours: monitoringCycleTime));
      index += 1;
    }
    return data;
  }

  static List<ElectricityTimeData> generateThisWeakData() {
    List<ElectricityTimeData> data = [];
    DateTime now = DateTime.now();
    // int monitoringCycleTime = 8;
    //DateTime lastWeekTime = DateTime(year)
    int weekday = now.weekday;
    int difference = 1 - weekday;
    DateTime thisMonday = now.add(Duration(days: difference));
    DateTime currentTime = DateTime(thisMonday.year, thisMonday.month, thisMonday.day);
    return generateFakeData(currentTime, monitoringDate: max(difference.abs(), 1));
    // 模擬上週7天的數據
  }
}
