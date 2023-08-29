import 'package:flutter/material.dart';

class DashboardDropdownWidget extends MaterialButton{
  // final Widget child;
  final Widget dropdownWidget;
  final GlobalKey layoutKey = GlobalKey();
  DashboardDropdownWidget({
    required this.dropdownWidget, required super.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: child,
    );
  }
}