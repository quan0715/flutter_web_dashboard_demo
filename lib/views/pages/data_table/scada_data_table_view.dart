import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/view_model/data_table/scada_data_table_view_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_grid.dart';
import 'package:web_dashboard/views/components/widget/dashboard_page.dart';
import 'package:web_dashboard/views/components/widget/dashboard_widget.dart';
class ScadaDataTableView extends StatelessWidget with DashboardPageTemplate{
  const ScadaDataTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScadaDataTableViewModel>(
      create: (context) => ScadaDataTableViewModel()..init(),
      child: DashboardPage(
        pageTitle: "監測點定時測量資料表",
        isSearchBarVisible: false,
        body: Consumer<ScadaDataTableViewModel>(
          builder: (context, viewModel, child) =>
          viewModel.loadingState == LoadingState.loading 
          ? loadingView()
          : Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FrameQuote(quoteText: "監測點定時測量資料表"),
              Expanded(child: ElectricityConsumptionDataGrid(dataSource: viewModel.dataSource,)),
            ],
          ),
        ),
      ),
    );
  }
}