import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/models/repo/config_repo_model.dart';
import 'package:web_dashboard/view_model/dashboard/dashboard_config_view_model.dart';
import 'package:web_dashboard/views/components/widget/dashboard_page.dart';
import 'package:web_dashboard/views/theme/theme.dart';

class DashboardConfigView extends StatefulWidget{
  const DashboardConfigView({Key? key}) : super(key: key);

  @override
  State<DashboardConfigView> createState() => _DashboardConfigViewState();
}

class _DashboardConfigViewState extends State<DashboardConfigView> {
  Widget configRowTemplate({required String title,required String description, required Widget child}){
    Widget titleAndSubTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: DashboardText.titleMedium(context)),
        Text(description, style: DashboardText.bodyMedium(context).copyWith(
          color: DashboardColor.secondary(context)
        ),),
      ],
    );
    Widget childWidget = SizedBox(
      width: 250,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: child,
        ),
      ),
    );
    return DashboardPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if(constraints.maxWidth > 560){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titleAndSubTitle,
                    childWidget
                  ],
                );
              }else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    titleAndSubTitle,
                    const SizedBox(height: 10,),
                    childWidget
                  ],
                );
              }
              
            }
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget settingToolBar(DashboardConfigViewModel viewModel){
    Widget toolButtons = Row(
      children: [
        MaterialButton(
            textColor: DashboardColor.error(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: DashboardColor.error(context).withOpacity(0.3))
            ),
            onPressed: viewModel.onReset,
            elevation: 1,
            child: const Row(
              children: [
                Icon(Icons.refresh),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text('Reset')),
              ],
            ),
          ),
          const SizedBox(width: 5,),
          MaterialButton(
            textColor: DashboardColor.primary(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: DashboardColor.primary(context).withOpacity(0.3))
            ),
            onPressed: () async => await viewModel.onSave(),
            elevation: 1,
            child: const Row(
              children: [
                Icon(Icons.save),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text('儲存')),
              ],
            ),
          ),
      ],
    );
    return DashboardPadding.object(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constrains) {
              if(constrains.maxWidth > 420){
                return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Text('儀表板設定', style: DashboardText.headLineSmall(context),),
                          Text('上次更新時間: ${DashBoardFormat.time(viewModel.lastUpdate)}', style: DashboardText.bodyMedium(context).copyWith(
                            color: DashboardColor.secondary(context)
                          ))
                        ],
                      ),
                      const Spacer(),
                      toolButtons,
                      
                    ],
                );
              } else{
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('帳號設定', style: DashboardText.headLineSmall(context),),
                    const SizedBox(height: 10,),
                    toolButtons, 
                  ]);
            }
            }
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget loadingFrame(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardConfigViewModel>(
      create: (context) => DashboardConfigViewModel()..init(),
      child: Consumer<DashboardConfigViewModel>(
        builder: (context, viewModel, child) => DashboardPage(
          pageTitle: "帳戶設定",
          isSearchBarVisible: false,
          body: viewModel.loadingState == LoadingState.loading 
            ? loadingFrame()
            : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  settingToolBar(viewModel),
                  configRowTemplate(
                    title: 'SCADA Cycle Interval 監測週期',
                    description: '監測資料搜集最小時間單位',
                    child: DropdownButton(
                        underline: Container(),
                        value: viewModel.cycleTime,
                        isExpanded: true,
                        items: viewModel.scadaCycleTimeOption.map((int time) => DropdownMenuItem(value: time, child: Text('$time min/次'))).toList(),
                        onChanged: (value) => viewModel.cycleTime = value as int,
                      ),
                  ),
                  configRowTemplate(
                    title: 'Rate Type 尖峰時段類型',
                    description: '設定固定或動態尖峰時段',
                    child: DropdownButton(
                        underline: Container(),
                        value: viewModel.rateType,
                        isExpanded: true,
                        items: RateType.values.map((RateType rateType) => DropdownMenuItem(value: rateType, child: Text(rateType.label))).toList(),
                        onChanged: (value) => viewModel.rateType = value as RateType,
                      ),
                  ),
                  configRowTemplate(
                    title: 'Section Type 尖峰時段分段方式',
                    description: '設定兩節或三節式計價電費, 尖峰、半尖峰、離峰時段',
                    child: StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return DropdownButton(
                            underline: Container(),
                            value: viewModel.section,
                            isExpanded: true,
                            items: RateSectionType.values.map((RateSectionType rateSectionType) => DropdownMenuItem(value: rateSectionType, child: Text(rateSectionType.label))).toList(),
                            onChanged: (value) => viewModel.section = value as RateSectionType,
                        );
                      }
                    )
                  ),
                  configRowTemplate(
                    title: 'Rate Voltage Type 電壓分類',
                    description: '設定電壓分類 (高壓、特高壓)',
                    child: StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return DropdownButton(
                            underline: Container(),
                            value: viewModel.voltage,
                            isExpanded: true,
                            items: RateVoltageType.values.map((RateVoltageType rateVoltageType) => DropdownMenuItem(value: rateVoltageType, child: Text(rateVoltageType.label))).toList(),
                            onChanged: (value) => viewModel.voltage = value as RateVoltageType,
                        );
                      }
                    )
                  ),
                  configRowTemplate(
                    title: 'Contract Capacity 契約容量',
                    description: '基礎電費支出計算依據',
                    child: TextField(
                      controller: TextEditingController(
                        text: DashBoardFormat.number(viewModel.contractCapacity)
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        labelText: '契約容量',
                        suffixText: 'kW',
                      ),
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      onSubmitted: (value) => viewModel.contractCapacity = int.parse(value), 
                    )
                  ),
              ]),
            ),
            ),
          ),
      );
  }
}