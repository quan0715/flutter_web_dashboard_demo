import 'package:flutter/material.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class DashboardPage extends StatelessWidget{
  const DashboardPage({
    super.key, 
    required this.pageTitle, 
    required this.isSearchBarVisible,
    required this.body,
    this.searchBar = const SizedBox.shrink(),
  });
  final String pageTitle;
  final bool isSearchBarVisible;
  final Widget body;
  final Widget searchBar;

  Widget loadingView(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget noneSupportScreenSizeView(BuildContext context){
    return Center(
      child: Text("layout not support", style: DashboardText.labelLarge(context)),
    );
  }

  Widget noneDataDialogView(BuildContext context){
    return Center(
      child: Text("無資料紀錄 確認伺服器連線狀態", style: DashboardText.labelLarge(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(title: pageTitle),
      drawer: const DashboardDrawer(),
      body: DashboardPadding.small(
        child: SizedBox.expand(
          child: DashboardPadding.small(
            child: Column(
              children: [
              isSearchBarVisible ? searchBar : const SizedBox.shrink(),
              Expanded(child: DashboardFrameCard(child: body)),
          ])
          ),         
        ),
      )
    );
  }
}

mixin class DashboardPageTemplate{

  Widget loadingView(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget noneSupportScreenSizeView(){
    return const Center(
      child: Text("layout not support"),
    );
  }

  Widget normalScreenSizeView(){
    return const Center(
      child: Text("layout not support"),
    );
  }
  
  Widget mediumScreenSizeView(){
    return const Center(
      child: Text("medium not support",),
    );
  }

  Widget smallScreenSizeView(){
    return const Center(
      child: Text("small screen not support"),
    );
  }

  
  Widget noneDataDialogView(){
    return const Center(
      child: Text("無資料紀錄 確認伺服器連線狀態",),
    );
  }
}