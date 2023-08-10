import 'package:intl/intl.dart';

class DashBoardFormat{
  // static NumberFormat _numberFormat = NumberFormat('#,###');
  static String todayTime(DateTime time) => DateFormat('HH:mm').format(time);
  static String dayTimeChartLabel(DateTime time) => DateFormat('MM/d \n hh a').format(time);
  static String time(DateTime time) => DateFormat('MM/dd hh:mm').format(time);
  static String timeWithSecond(DateTime time) => DateFormat('MM/dd HH:mm:ss').format(time);
  static String dateTime(DateTime time) => DateFormat('MM/dd').format(time);
  static String number(int value) => NumberFormat('#,###').format(value);
}