import 'package:flutter/material.dart';

class HomePageBaseViewModel extends ChangeNotifier{
  int currentIndex = 0;
  List<Map> navigationBarState = [
    {
      "title": "電表數據總覽",
      "route": "/dashboard/1",
      "isSelected" : true,
    },
    {
      "title": "所有電表數據",
      "route": "/dashboard/2",
      "isSelected" : false,
    },
    {
      "title": "測試版",
      "route": "/dashboard/test",
      "isSelected" : false,
    },
  ];

  void switchDashboardPage(int index){
    currentIndex = index;
    for(Map action in navigationBarState){
      action["isSelected"] = index == navigationBarState.indexOf(action);
    }
    notifyListeners();
  }
}