
import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';

class DashboardThemeManager extends ChangeNotifier{

  ThemeData _theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Ibm.blue().color, 
      brightness: Brightness.dark
    ),
    useMaterial3: true,
  );

  get theme => _theme;
  get isDark => _theme.brightness == Brightness.dark;
  
  // void toggle
  void toggleTheme(){
    _theme = _theme.brightness == Brightness.dark 
    ? ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Ibm.blue().color, 
        brightness: Brightness.light
      ),
      useMaterial3: true,
    )
    : ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Ibm.blue().color, 
        brightness: Brightness.dark
      ),
      useMaterial3: true,
    );
    notifyListeners();
  }

}