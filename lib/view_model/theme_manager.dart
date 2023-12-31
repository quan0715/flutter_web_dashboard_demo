
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
    _theme = isDark
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
  String get logoPath => _theme.brightness == Brightness.dark ? "assets/ibm/IBM_logo_dark.png" : "assets/ibm/IBM_logo_light.png";
  IconData get icon => _theme.brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode;
  Image get logo => _theme.brightness == Brightness.dark ? Image.asset(logoPath) : Image.asset(logoPath);
}