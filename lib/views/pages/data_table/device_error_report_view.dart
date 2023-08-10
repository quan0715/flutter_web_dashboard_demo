import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/views/theme/theme.dart';
import 'package:web_dashboard/view_model/dashboard/device_error_report_view_model.dart';
import 'package:web_dashboard/views/components/widget/app_bar.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/data_grid.dart';
import 'package:web_dashboard/views/components/widget/drawer.dart';
import 'package:web_dashboard/views/components/widget/quote.dart';

class DeviceErrorReportView extends StatefulWidget {
  const DeviceErrorReportView({super.key});

  @override
  State<DeviceErrorReportView> createState() => _DeviceErrorReportViewState();
}

class _DeviceErrorReportViewState extends State<DeviceErrorReportView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeviceErrorReportViewModel>(
      create: (context) => DeviceErrorReportViewModel()..init(),
      child: Consumer<DeviceErrorReportViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: const DashboardAppBar(title: "用電異常清單"),
          drawer: const DashboardDrawer(),
          body: SizedBox.expand(
            child: DashboardPadding.large(
              child: DashboardFrameCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FrameQuote(quoteText: "用電異常清單", style: DashboardText.titleLarge(context)),
                    // DashboardDivider.small(),
                    // DashboardSizedBox.large(),
                    DashboardPadding.object(
                      child: Expanded(
                        child:  DeviceErrorReportTableDataGrid(dataSource: viewModel.dataSource),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}