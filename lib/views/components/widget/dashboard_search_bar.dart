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
    List<Widget> childrenWithDivider = [];
    for (int i=0; i < children.length ; i++){
      childrenWithDivider.add(children[i]);
      if(i != children.length - 1 || i != 0){
        childrenWithDivider.add(
          const SizedBox(height: 35, child:  VerticalDivider(width: 20, thickness: 2,))
        );
      }
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: 70,
      ),
      child: DashboardFrameCard(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        elevation: 3,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: childrenWithDivider,
          )
        ),
      ),
    );
  }
}

