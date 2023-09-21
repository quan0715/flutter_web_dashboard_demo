import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/view_model/data_table/scada_data_table_view_model.dart';
import 'package:web_dashboard/views/components/data/electricity_consumption_table/data_grid.dart';
import 'package:web_dashboard/views/components/widget/dashboard_date_picker.dart';
import 'package:web_dashboard/views/components/widget/dashboard_page.dart';
import 'package:web_dashboard/views/components/widget/dashboard_widget.dart';
import 'package:web_dashboard/views/pages/dashboard/consumption_report_dashboard_view.dart';
class ScadaDataTableView extends StatelessWidget with DashboardPageTemplate{
  const ScadaDataTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScadaDataTableViewModel>(
      create: (context) => ScadaDataTableViewModel()..init(),
      child: Consumer<ScadaDataTableViewModel>(
        builder: (context, viewModel, child) => DashboardPage(
          pageTitle: "監測點定時測量資料表",
          isSearchBarVisible: true ,
          searchBar: viewModel.loadingState == LoadingState.loading 
          ? const SizedBox.shrink()
          : DashboardSearchBar(
              children: [
                // LevelFilterList(
                //   treeSearchCard: TreeSearchCard(
                //     searchTree: viewModel.consumptionDataGroupSearchTree,
                //     filterOrder: viewModel.filterOrder,
                //     enableReordering: false,
                //     onValueChange: viewModel.refreshPage,
                //   ),
                //   treeSearchLegend: TreeSearchLegend(
                //     filterTree: viewModel.filterSearchTreeNode,
                //   ),
                // ),
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
      ),
    );
  }
}