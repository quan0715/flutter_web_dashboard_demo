import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/views/components/widget/dashboard_page.dart';
import 'package:web_dashboard/view_model/data_table/device_error_report_view_model.dart';
import 'package:web_dashboard/views/components/data/device_error_report_table/data_grid.dart';
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
        builder: (context, viewModel, child) => DashboardPage(
          pageTitle: "用電異常清單",
          isSearchBarVisible: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FrameQuote(quoteText: "用電異常清單"),
              Expanded(
                child:  DeviceErrorReportTableDataGrid(dataSource: viewModel.dataSource),
              ),
            ],
          ),
          ),
        ),
      
    );
  }
}