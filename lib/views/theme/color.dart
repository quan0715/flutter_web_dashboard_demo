import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/palettes.dart';

class DashboardColor{
  static Color correct = const Color(0xFF4CAF50);
  static Color incorrect = Colors.red.shade400;
  static Color colorSeed = const Ibm.blue().color;
  static Color primary(BuildContext context) => Theme.of(context).colorScheme.primary; 
  static Color secondary(BuildContext context) => Theme.of(context).colorScheme.secondary;
  static Color background(BuildContext context) => Theme.of(context).colorScheme.background;
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color error(BuildContext context) => Theme.of(context).colorScheme.error;
  static Color onPrimary(BuildContext context) => Theme.of(context).colorScheme.onPrimary;
  static Color onSecondary(BuildContext context) => Theme.of(context).colorScheme.onSecondary;
  static Color onBackground(BuildContext context) => Theme.of(context).colorScheme.onBackground;
  static Color onSurface(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color onError(BuildContext context) => Theme.of(context).colorScheme.onError;
  static Color surfaceVariant(BuildContext context) => Theme.of(context).colorScheme.surfaceVariant;
  
}