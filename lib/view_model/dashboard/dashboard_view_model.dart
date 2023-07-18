import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier{

  // temp data which just for testing

  // Variable declaration
  int _currentSelectedFactoryIndex = 0;
  int _currentSelectedCategoryIndex = 1;
  int _currentSelectedCardIndex = 0;
  List<String> factoryName = ["煉製一廠", "煉製二廠", "煉製三廠"];
  List<String> categoryName = ["氣體", "水質", "毒化物"];
  List<IconData> categoryIcon = [Icons.air, Icons.water, Icons.science];

  // get method

  int get currentSelectedFactoryIndex => _currentSelectedFactoryIndex;
  String get currentSelectedFactoryName => factoryName[_currentSelectedFactoryIndex];
  int get currentSelectedCategoryIndex => _currentSelectedCategoryIndex;
  String get currentSelectedCategoryName => categoryName[_currentSelectedCategoryIndex];
  IconData get currentSelectedCategoryIcon => categoryIcon[_currentSelectedCategoryIndex];
  String get dashboardTitle => "$currentSelectedFactoryName - $currentSelectedCategoryName";
  int get currentSelectedCardIndex => _currentSelectedCardIndex;

  // set method (with notifyListeners()) 

  set currentSelectedFactoryIndex(int value){
    _currentSelectedFactoryIndex = value;
    _currentSelectedCategoryIndex = 0;
    _currentSelectedCardIndex = 0;
    notifyListeners();
  } 
  set currentSelectedCategoryIndex(int value){
    _currentSelectedCategoryIndex = value;
    _currentSelectedCardIndex = 0;
    notifyListeners();
  }
  set currentSelectedCardIndex(int value){
    _currentSelectedCardIndex = value;
    notifyListeners();
  }

  // functional method

  // fake data
  List<List<dynamic>> bounds = [
      [0, 50, "優良", Colors.green],
      [51, 100, "普通", Colors.yellow],
      [101, 150, "輕度污染", Colors.orange],
      [151, 200, "中度污染", Colors.red],
      [201, 250, "重度污染", Colors.purple]
    ];
    List? getBound(int aqiValue){
      for(dynamic data in bounds){
        if(aqiValue >= data[0] && aqiValue <= data[1]){
          return data;
        }
      }
    }
    get tar{
      data.sort((a, b) => (a["value"] as int).compareTo(b["value"] as int));
      return data.last;
    }
    get data =>[
        {
          "name" : "PM 2.5",
          "value" : 31,
          "lastTimeValue": 35,
          "unit" : "μg/m3",
          "bounds": getBound(31),
        },
        {
          "name" : "PM 10",
          "value" : 155,
          "lastTimeValue": 120,
          "unit" : "μg/m3",
          "bounds": getBound(155),
        },
        {
          "name" : "SO\u2082",
          "value" : 79,
          "lastTimeValue": 92,
          "unit" : "ppb",
          "bounds": getBound(79),
        },
        {
          "name" : "O\u2083",
          "value" : 68,
          "lastTimeValue": 62,
          "unit" : "ppm",
          "bounds": getBound(68),
        },
        {
          "name" : "CO\u2082",
          "value" : 123,
          "lastTimeValue": 121,
          "unit" : "ppm",
          "bounds": getBound(123),
        },
        {
          "name" : "NO\u2082",
          "value" : 132,
          "lastTimeValue": 153,
          "unit" : "ppm",
          "bounds": getBound(132),
        },
        // {
        //   "name" : "SO\u2083",
        //   "value" : 102,
        //   "lastTimeValue": 240,
        //   "unit" : "ppm",
        //   "bounds": getBound(102),
        // },
      ];

    get waterData => [
      {
        "name" : "氫離子濃度",
        "value" : 5,
        "lastTimeValue": 7,
        "unit" : "",
        "label" : "異常",
        "color": Colors.red,
      },
      {
        "name" : "氰化物濃度",
        "value" : 1.0,
        "lastTimeValue": 1.0,
        "unit" : "mg/l",
        "label" : "正常",
        "color": Colors.green,
      },
      {
        "name" : "硝酸鹽氮",
        "value" : 60,
        "lastTimeValue": 50,
        "unit" : "mg/l",
        "label" : "異常",
        "color": Colors.red,
      },
      {
        "name" : "生化需氧量",
        "value" : 7,
        "lastTimeValue": 9,
        "unit" : "mg/l",
        "label" : "正常",
        "color": Colors.green,
      },
      {
        "name" : "BOD(7日平均)",
        "value" : 6.3,
        "lastTimeValue": 9,
        "unit" : "mg/l",
        "label" : "正常",
        "color": Colors.green,
      },
    ];

}