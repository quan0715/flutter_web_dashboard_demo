import 'package:flutter/material.dart';
import 'package:web_dashboard/views/theme/text.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget{
  const DashboardAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: false,
      title: Text(title, style: DashboardText.titleLarge(context)),
    ); 
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}