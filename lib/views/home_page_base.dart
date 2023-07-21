import 'package:flutter/material.dart';
import 'package:web_dashboard/view_model/home_page_view_model.dart';
import 'package:web_dashboard/theme_manager.dart';
import 'package:provider/provider.dart';

class HomePageBaseView extends StatefulWidget {
  final Widget body;
  const HomePageBaseView({super.key, required this.body});
  
  @override
  State<HomePageBaseView> createState() => _HomePageBaseViewState();
}

class _HomePageBaseViewState extends State<HomePageBaseView> {
  
  List<Widget> getActionButtonList(HomePageBaseViewModel vm){
    Color? selectedColor = Theme.of(context).colorScheme.primary;
    Color? unSelectedColor = Theme.of(context).colorScheme.primary.withOpacity(0.5);
    return List.from(vm.navigationBarState.map((Map t) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextButton(
        onPressed: () {
          vm.switchDashboardPage(vm.navigationBarState.indexOf(t));
          Navigator.pushNamed(context, t["route"] as String);
        },
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          shape: LinearBorder.bottom(
            side:  t["isSelected"] as bool 
            ? BorderSide(
              color:selectedColor,
              width: 2,
            ): BorderSide.none,
          )
        ),
        child: Text(
          t["title"],
          style: TextStyle(
            color: t["isSelected"] as bool ? selectedColor : unSelectedColor,
            fontWeight: t["isSelected"] as bool ? FontWeight.bold : FontWeight.normal,
          ),
        ) ,
    ))));
  }
  PreferredSizeWidget topNavigationBar(BuildContext context, HomePageBaseViewModel vm) {
    return AppBar(
      leading: MaterialButton(
        onPressed: (){},
        child: Image.asset(
         'images/logo.png'
        ),
      ),
      leadingWidth: 100,
      title: Text('IBM能源管理平台', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: false,
      actions: [
        Consumer<DashboardThemeManager>(
          builder: (context, themeManager, child) => IconButton(
            onPressed: (){
              themeManager.toggleTheme();
            },
            icon: themeManager.isDark ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
          ),
        ),
        ...getActionButtonList(vm)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageBaseViewModel>(
      builder: (context, homePageViewModel, child) => Scaffold(
        appBar: topNavigationBar(context, homePageViewModel),
        body: widget.body,
      ),
    );
  }
}