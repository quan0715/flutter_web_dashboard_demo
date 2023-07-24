import 'package:flutter/material.dart';

class DashboardText{
  static TextStyle titleLarge(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle titleMedium(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle titleSmall(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.titleSmall!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle bodyLarge(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle bodyMedium(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle bodySmall(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle labelLarge(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.labelLarge!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle labelMedium(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static TextStyle labelSmall(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.labelSmall!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static headLineLarge(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static headLineMedium(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
  static headLineSmall(BuildContext context, {bool bold = true}){
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

}