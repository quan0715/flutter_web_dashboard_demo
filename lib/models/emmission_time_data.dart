import 'dart:math';

import 'package:flutter/material.dart';

class EmissionTimeData{
  final DateTime time;
  final double amount;

  EmissionTimeData({required this.time, required this.amount});

  static List<EmissionTimeData> generateFakeWeaklyData() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    int difference = 1 - weekday;
    DateTime thisMonday = now.add(Duration(days: difference));
    thisMonday = DateTime(thisMonday.year, thisMonday.month, thisMonday.day);
    DateTime lastMonday = thisMonday.subtract(const Duration(days: 7));
    DateTime currentTime = lastMonday;
    return generateFakeData(currentTime);
  }

  static List<EmissionTimeData> generateFakeData(DateTime startTime,{int monitoringDate = 7,int monitoringCycleTime = 8, int initAmount = 120}){
    DateTime currentTime = startTime;
    double previousPower = initAmount.toDouble(); // 初始用電量
    List<EmissionTimeData> data = [];
    int index = 0;
    while (currentTime.isBefore(DateTime.now()) && index < (monitoringDate * 24) ~/ monitoringCycleTime) {
      // double fluctuation = Random().nextDouble() * Random().nextDouble() * Random().nextDouble() * 50;
      // if (index % 3 == 0) { // 高峰时段
      //   fluctuation += Random().nextDouble() * 50;
      // } else if (index % 5 == 0) { // 低峰时段
      //   fluctuation -= Random().nextDouble() * 100;
      // }
      // double power = previousPower + fluctuation;
        
      // 最小用電量 0
      // if (power < 0) {
      //   power = 0;
      // }
      // // 更新前一时间点的用电量
      // previousPower = power;

      data.add(EmissionTimeData(time: currentTime, amount: Random().nextDouble() * initAmount));
      currentTime = currentTime.add(Duration(hours: monitoringCycleTime));
      // index += 1;
    }
    return data;
  }

  static List<EmissionTimeData> generateThisWeakData() {
    List<EmissionTimeData> data = [];
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
