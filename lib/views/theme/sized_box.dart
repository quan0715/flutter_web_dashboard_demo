import 'package:flutter/material.dart';

class DashboardSizedBox extends StatelessWidget{
  const DashboardSizedBox({
    super.key,
    this.width,
    this.height,
    this.child
  });
  final double? width;
  final double? height;
  final Widget? child;

  factory DashboardSizedBox.large({
    double? width = 15,
    double? height = 15,
    Widget? child,
  }) => DashboardSizedBox(
    width: width,
    height: height,
    child: child
  );

  factory DashboardSizedBox.medium({
    double? width = 10,
    double? height = 10,
    Widget? child
  }) => DashboardSizedBox(
    width: width,
    height: height,
    child: child
  );

  factory DashboardSizedBox.small({
    double? width = 5,
    double? height = 5,
    Widget? child
  }) => DashboardSizedBox(
    width: width,
    height: height,
    child: child
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}