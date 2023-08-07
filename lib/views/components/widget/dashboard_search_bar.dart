import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/views/theme/theme.dart';
import 'package:web_dashboard/view_model/dashboard/electricity_consumption_view_model.dart';
import 'package:web_dashboard/views/components/widget/dashboard_frame_card.dart';

class DashboardSearchBar extends StatefulWidget {
  const DashboardSearchBar({super.key});

  @override
  State<DashboardSearchBar> createState() => _DashboardSearchBarState();
}

class _DashboardSearchBarState extends State<DashboardSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ElectricityConsumptionDashboardViewModel>(
      builder: (context, viewModel,child)=> SizedBox(
        height: 70,
        child: DashboardFrameCard(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          elevation: 3,
          child: Row(
            children: [
              DropdownButton<String>(
                // drop sown menu for factory G1, G2, G3
                padding: EdgeInsets.zero,
                elevation: 0,
                // icon: Icon(Icons.),
                style: DashboardText.titleMedium(context),
                underline: Container(),
                items : viewModel.factoryList.map<DropdownMenuItem<String>>(
                  (label) => DropdownMenuItem(
                    value: label,
                    child: RawChip(
                      side: BorderSide.none,
                      avatar: Icon(Icons.factory_rounded, color: DashboardColor.primary(context)),
                      label: Text("工廠: $label")
                    )
                  ),
                ).toList(),
                onChanged: (value) => viewModel.setTargetFactoryId = value!,
                value: viewModel.targetFactoryId
            ),
              VerticalDivider(width: 15, color: DashboardColor.surfaceVariant(context), thickness: 3, indent: 5,endIndent: 5,),
              DropdownButton<String>(
                // drop down menu for building M1, M2, M3
                padding: EdgeInsets.zero,
                elevation: 0,
                style: DashboardText.titleMedium(context),
                underline: Container(),
                items: viewModel.buildingList.map<DropdownMenuItem<String>>(
                  (label) => DropdownMenuItem(
                    value: label,
                    child: RawChip(
                      side: BorderSide.none,
                      avatar: Icon(Icons.home_rounded, color: DashboardColor.primary(context)),
                      label: Text("建築: $label")
                    )
                  ),
                ).toList(),
                onChanged: (value) => viewModel.setTargetBuildingId = value!,
                value: viewModel.targetBuildingId),
              VerticalDivider(width: 15, color: DashboardColor.surfaceVariant(context), thickness: 3, indent: 5,endIndent: 5,),
              // DropdownButton<DateTime>(
              //   // drop down menu for building M1, M2, M3
              //   padding: EdgeInsets.zero,
              //   elevation: 0,
              //   style: DashboardText.titleMedium(context),
              //   underline: Container(),
              //   items: viewModel.dateTimeList.map<DropdownMenuItem<DateTime>>(
              //     (label) => DropdownMenuItem(
              //       value: label,
              //       child: RawChip(
              //         avatar: Icon(Icons.timer, color: DashboardColor.primary(context)),
              //         label: Text("日期: ${DashBoardFormat.time(label)}")
              //       )
              //     ),
              //   ).toList(),
              //   onChanged: (value) => viewModel.setTargetDateTime = value!,
              //   value: viewModel.targetDateTime),
              DropdownButton<String>(
                // drop down menu for assetType
                padding: EdgeInsets.zero,
                elevation: 0,
                style: DashboardText.titleMedium(context),
                underline: Container(),
                items: viewModel.assetTypeList.map<DropdownMenuItem<String>>(
                  (label) => DropdownMenuItem(
                    value: label,
                    child: RawChip(
                      side: BorderSide.none,
                      avatar: Icon(Icons.factory , color: DashboardColor.primary(context)),
                      label: Text("設備類型: $label")
                    )
                  ),
                ).toList(),
                onChanged: (value) => viewModel.setTargetAssetType = value!,
                value: viewModel.targetAssetType),
              const Spacer(),
              Expanded(
                flex: 3,
                child: SearchBar(
                  leading: Icon(Icons.search_rounded, color: DashboardColor.primary(context)),
                  elevation: MaterialStateProperty.all(0),
                  hintText: "搜尋電表",
                  onChanged: (value) => {},
                ),
              ),
              const Spacer(),
              ChoiceChip(
                iconTheme: IconThemeData(color: DashboardColor.onError(context), size: 32),
                backgroundColor: DashboardColor.surface(context),
                label: viewModel.isShowErrorOnly ? const Text("只顯示異常") : const Text("顯示全部"),
                selected: viewModel.isShowErrorOnly,
                selectedColor: DashboardColor.error(context).withOpacity(0.1),
                side: 
                  viewModel.isShowErrorOnly
                    ? BorderSide(color: DashboardColor.error(context).withOpacity(0.5), width: 1)
                    : BorderSide.none,
                onSelected: (value) => viewModel.setIsShowAll = value,
              ),
              VerticalDivider(width: 15, color: DashboardColor.surfaceVariant(context), thickness: 3, indent: 5,endIndent: 5,),
              Switch(
                thumbIcon: MaterialStateProperty.all(
                  viewModel.isDashboardView
                    ? Icon(Icons.dashboard, color: DashboardColor.primary(context))
                    : const Icon(Icons.table_chart, color: Colors.white)
                ),
                activeColor: DashboardColor.primary(context).withOpacity(0.1),
                inactiveThumbColor: Colors.amber,
                value: viewModel.isDashboardView, 
                onChanged: (value) => viewModel.setIsDashboard = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
