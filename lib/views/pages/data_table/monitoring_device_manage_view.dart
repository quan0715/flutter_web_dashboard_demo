import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/views/components/widget/dashboard_page.dart';
import 'package:web_dashboard/views/theme/theme.dart';
import 'package:web_dashboard/view_model/data_table/monitoring_device_manage_view_model.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/data/device_manage_table/data_grid.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';

class MonitoringDeviceManageView extends StatefulWidget {
  const MonitoringDeviceManageView({super.key});

  @override
  State<MonitoringDeviceManageView> createState() => _MonitoringDeviceManageViewState();
}

class _MonitoringDeviceManageViewState extends State<MonitoringDeviceManageView> {

  Widget getToolBar(viewModel){
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: DashboardColor.secondary(context),
          width: 1,
        )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
    Widget buttonList = Row(
      children: [
        ElevatedButton.icon(
          style: buttonStyle,
          onPressed: ()async{
              var checker = await showDialog(context: context, builder: (context) => AlertDialog(
                title: const Text("確定要上傳新的監測資料嗎？"),
                content: const Text("匯入監測資料將會覆蓋原有的監測資料"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false), 
                    child: const Text("取消")),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true), 
                    child: const Text("確定")),
                ],
              ));
              if(checker){
                await viewModel.uploadDataToRepo();
                if(mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("上傳成功"),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ));
                }
              }
            }, 
          icon: const Icon(Icons.upload_file), 
          label: const Text("save file")
        ),
        DashboardSizedBox.large(),
        ElevatedButton.icon(
          style: buttonStyle,
          onPressed: ()async{
            await viewModel.uploadCsvFile();
            if(mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("匯入成功"),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ));
              }
          },
          icon: const Icon(Icons.download), 
          label: const Text("匯入監測資料")),
    ],);
    return LayoutBuilder(
      builder: (context, constraints) => Column(
            children: [
              Row(
                children: [
                  FrameQuote(quoteText: "檢測點設備管理", style: DashboardText.titleLarge(context)),
                  const Spacer(),
                  constraints.maxWidth > 700 ? buttonList : Container(),
                ],
              ),
              constraints.maxWidth <= 700 ? buttonList : Container(),
              Visibility(
                visible: viewModel.loadingState == LoadingState.loading,
                child: DashboardPadding.small(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(viewModel.missionDescription),
                      LinearProgressIndicator(
                        value: viewModel.missionProgressValue.toDouble(),
                        semanticsLabel: "Loading",
                      ),
                    ],
                  ),
                )
              ),
            ],
      ),
    );
  }

  Widget getDataGrid(){
    return Consumer<MonitoringDeviceManageViewModel>(
      builder: (context, viewModel, child) => 
        viewModel.monitoringDeviceList.isNotEmpty 
        ? DeviceManagingTableDataGrid(
          dataSource: viewModel.monitoringDeviceList,
        ): Center(
          child: MaterialButton(
            onPressed: viewModel.uploadCsvFile, 
            child: Text("尚無監測點 +", style: DashboardText.titleLarge(context).copyWith(
              color: DashboardColor.onSurface(context).withOpacity(0.6)
            )),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MonitoringDeviceManageViewModel>(
      create: (context) => MonitoringDeviceManageViewModel()..init(),
      child: Consumer<MonitoringDeviceManageViewModel>(
        builder: (context, viewModel, child) => DashboardPage(
          isSearchBarVisible: false,
          pageTitle: "監測點管理",
          body: Column(
            children: [
              getToolBar(viewModel),
              Expanded(
                child: getDataGrid()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
