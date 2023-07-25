import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/theme/theme.dart';
import 'package:web_dashboard/view_model/dashboard/monitoring_device_manage_view_model.dart';
import 'package:web_dashboard/views/components/app_bar.dart';
import 'package:web_dashboard/views/components/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/data/device_manage_table/data_grid.dart';
import 'package:web_dashboard/views/components/drawer.dart';
import 'package:web_dashboard/views/components/quote.dart';

class MonitoringDeviceManageView extends StatefulWidget {
  const MonitoringDeviceManageView({super.key});

  @override
  State<MonitoringDeviceManageView> createState() => _MonitoringDeviceManageViewState();
}

class _MonitoringDeviceManageViewState extends State<MonitoringDeviceManageView> {

  Widget getToolBar(){
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
    return Consumer<MonitoringDeviceManageViewModel>(
      builder: (context, viewModel, child) => 
        DashboardPadding.object(
          child: Row(
            children: [
              FrameQuote(quoteText: "檢測點設備管理", style: DashboardText.headLineMedium(context)),
              const Spacer(),
              // ElevatedButton.icon(
              //   style: buttonStyle,
              //   onPressed: (){}, 
              //   icon: const Icon(Icons.upload), 
              //   label: const Text("匯出")),
              DashboardSizedBox.large(),
              ElevatedButton.icon(
                style: buttonStyle,
                onPressed: viewModel.upload, 
                icon: const Icon(Icons.download), 
                label: const Text("匯入")),
            ],
          )
        ),
    );
  }

  Widget getDataGrid(){
    return Consumer<MonitoringDeviceManageViewModel>(
      builder: (context, viewModel, child) => 
        DashboardPadding.object(child: 
        DashboardFrameCard(
          elevation: 1,
          child: viewModel.monitoringDeviceList.isNotEmpty 
          ? DeviceManagingTableDataGrid(
            dataSource: viewModel.monitoringDeviceList,
          ): Center(
            child: MaterialButton(
              onPressed: viewModel.upload, 
              child: Text("尚無監測點 +", style: DashboardText.titleLarge(context).copyWith(
                color: DashboardColor.onSurface(context).withOpacity(0.6)
              )),
            ),
          ),
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MonitoringDeviceManageViewModel>(
      create: (context) => MonitoringDeviceManageViewModel(),
      child: Consumer<MonitoringDeviceManageViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: const DashboardAppBar(title: "監測點管理",),
          drawer: const DashboardDrawer(),
          body: DashboardPadding.large(
            child: SizedBox.expand(
              // color: DashboardColor.error(context),
              child: Column(
                children: [
                  getToolBar(),
                  Expanded(
                    child: getDataGrid()
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}