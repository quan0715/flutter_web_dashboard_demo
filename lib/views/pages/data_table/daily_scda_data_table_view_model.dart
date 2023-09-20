import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/view_model/data_table/daily_scada_data_view_model.dart';
import 'package:web_dashboard/view_model/data_table/scada_data_table_view_model.dart';
import 'package:web_dashboard/views/components/data/sum_consumption_table.dart/data_grid.dart';
import 'package:web_dashboard/views/components/widget/dashboard_page.dart';
import 'package:web_dashboard/views/components/widget/dashboard_widget.dart';
class DailyScadaDataTableView extends StatelessWidget with DashboardPageTemplate{
  const DailyScadaDataTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DailyScadaDataViewModel>(
      create: (context) => DailyScadaDataViewModel()..init(),
      child: DashboardPage(
        pageTitle: "每日監測總量資料表",
        isSearchBarVisible: false,
        body: Consumer<DailyScadaDataViewModel>(
          builder: (context, viewModel, child) =>
          viewModel.loadingState == LoadingState.loading 
          ? loadingView()
          : Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FrameQuote(quoteText: "每日監測總量資料表"),
              Expanded(
                child: SumOfElectricityConsumptionDataGrid(
                dataSource: viewModel.dataSource,
              )),
            ],
          ),
        ),
      ),
    );
  }
}