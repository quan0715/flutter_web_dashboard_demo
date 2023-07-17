import 'package:intl/intl.dart';

class DashBoardFormat{
  // static NumberFormat _numberFormat = NumberFormat('#,###');
  static String todayTime(DateTime time) => DateFormat('HH:mm').format(time);
  static String dayTimeChartLabel(DateTime time) => DateFormat('MM/d \n hh a').format(time);
  static String time(DateTime time) => DateFormat('MM/dd hh:mm').format(time);
  static String number(int value) => NumberFormat('#,###').format(value);
}