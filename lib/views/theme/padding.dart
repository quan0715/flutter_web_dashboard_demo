import 'package:flutter/material.dart';

class DashboardPadding extends StatelessWidget{
  const DashboardPadding({
    Key? key,
    required this.child,
    this.padding
  }) : super(key: key);
  
  final Widget child;
  final EdgeInsetsGeometry? padding;

  factory DashboardPadding.large({
    required Widget child,
    EdgeInsetsGeometry? padding
  }) => DashboardPadding(
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    child: child
  );

  factory DashboardPadding.medium({
    required Widget child,
    EdgeInsetsGeometry? padding
  }) => DashboardPadding(
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: child
  );

  factory DashboardPadding.small({
    required Widget child,
    EdgeInsetsGeometry? padding
  }) => DashboardPadding(
    padding: padding ?? const EdgeInsets.all(10),
    child: child
  );
  factory DashboardPadding.object({
    required Widget child,
    EdgeInsetsGeometry? padding
  }) => DashboardPadding(
    padding: padding ?? const EdgeInsets.all(20),
    child: child
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(10),
      child: child,
    );
  }
}