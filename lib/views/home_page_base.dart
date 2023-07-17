import 'package:flutter/material.dart';
import 'package:prologium_project_demo/view_model/home_page_view_model.dart';
import 'package:prologium_project_demo/views/common/padding.dart';
import 'package:prologium_project_demo/views/common/text.dart';
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
      // leading: MaterialButton(
      //   onPressed: (){},
      //   child: Image.network(
      //    // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8SmO_2F2_Pi8LSur7KYo09DSlUozTD78MTqi-QWRNIieV4ppcmfL4iakkVrrKGf15_sI&usqp=CAU"
      //   'https://campustalent.careercenter.ncu.edu.tw/storage/company_logo/28224797_logo.png',
      //   ),
      // ),
      automaticallyImplyLeading: false,
      title: DashboardPadding.small(
        padding: const EdgeInsets.all(8.0),
        child: const Text('IBM安衛環數據監控平台'),
      ),
      titleTextStyle: DashboardText.titleLarge(context),
      centerTitle: false,
      actions: getActionButtonList(vm),
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