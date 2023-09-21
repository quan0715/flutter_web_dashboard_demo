import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/models/search/filter_search_node.dart';
import 'package:web_dashboard/view_model/data_table/daily_scada_data_view_model.dart';
import 'package:web_dashboard/views/components/data/sum_consumption_table.dart/data_grid.dart';
import 'package:web_dashboard/views/components/widget/dashboard_date_picker.dart';
import 'package:web_dashboard/views/components/widget/dashboard_page.dart';
import 'package:web_dashboard/views/components/widget/dashboard_widget.dart';
import 'package:web_dashboard/views/pages/dashboard/consumption_report_dashboard_view.dart';
class DailyScadaDataTableView extends StatelessWidget with DashboardPageTemplate{
  const DailyScadaDataTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DailyScadaDataViewModel>(
      create: (context) => DailyScadaDataViewModel()..init(),
      child: Consumer<DailyScadaDataViewModel>(
        builder: (context, viewModel, child) => DashboardPage(
          pageTitle: "每日監測總量資料表",
          isSearchBarVisible: true,
          searchBar: viewModel.loadingState == LoadingState.loading 
          ? const SizedBox.shrink()
          : DashboardSearchBar(
            children: [
              LevelFilterList(
                treeSearchCard: TreeSearchCard(
                  searchTree: viewModel.consumptionDataGroupSearchTree,
                  filterOrder: viewModel.filterOrder,
                  enableReordering: false,
                  onValueChange: viewModel.refreshPage,
                ),
                treeSearchLegend: TreeSearchLegend(
                  filterTree: viewModel.filterSearchTreeNode,
                ),
              ),
              Row(
                children: [
                  DashboardDatePicker(
                    buttonLabel: "開始時間",
                    initDate: viewModel.searchStartTime,
                    onDateChange: (date) => viewModel.searchStartTime = date,
                  ),
                  const Icon(Icons.arrow_right_sharp),
                  DashboardDatePicker(
                    buttonLabel: "截止時間",
                    initDate: viewModel.searchEndTime,
                    onDateChange: (date) => viewModel.searchEndTime = date,
                  )
                ],
              ),
            ],
          ),
          body: viewModel.loadingState == LoadingState.loading 
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