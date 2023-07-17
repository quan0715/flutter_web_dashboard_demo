import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier{

  // temp data which just for testing

  // Variable declaration
  int _currentSelectedFactoryIndex = 0;
  int _currentSelectedCategoryIndex = 0;
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

  // set method (with notifyListeners()) 

  set currentSelectedFactoryIndex(int value){
    _currentSelectedFactoryIndex = value;
    notifyListeners();
  } 
  set currentSelectedCategoryIndex(int value){
    _currentSelectedCategoryIndex = value;
    notifyListeners();
  }

  // functional method

}