import 'package:flutter/material.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';

class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({
    super.key,
    required this.children,
  });
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: DashboardFrameCard(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        elevation: 3,
        child: Row(
          children: children
        ),
      ),
    );
  }
}

