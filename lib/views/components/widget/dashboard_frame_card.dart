import 'package:flutter/material.dart';

class DashboardFrameCard extends StatelessWidget{
  // for each frame in dashboard
  // padding: EdgeInsets.all(20.0) by default, is the padding for inside child
  // elevation: 2.0 by default, is the elevation for the card
  // child: SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height) by default, is the child of the card
  const DashboardFrameCard({
    super.key,
    this.padding = const EdgeInsets.all(20.0),
    this.elevation = 2.0,
    this.color,
    this.child,
  });
  final EdgeInsets? padding;
  final double? elevation;
  final Widget? child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation ?? 0.0,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20.0),
        child: child ?? SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height
        )
      )
    );
  }
}

class SingleChildScrollDashboardFrame extends StatelessWidget{
  const SingleChildScrollDashboardFrame({
    super.key,
    this.padding = const EdgeInsets.all(20.0),
    this.elevation = 2.0,
    this.child,
  });
  final EdgeInsets? padding;
  final double? elevation;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 0.0,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: child ?? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height
          )
        )
      )
    );
  }

}