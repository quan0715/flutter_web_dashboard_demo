import 'dart:math';

import 'package:web_dashboard/models/ammeter_model.dart';
import 'package:web_dashboard/models/electricity_flow_data.dart';
import 'package:web_dashboard/models/error_report_model.dart';
import 'package:web_dashboard/models/workspace_model.dart';

class FakeData{
  
  static List<AmmeterErrorReportModel> generateFakeErrorReport(AmmeterModel model){
    List<AmmeterErrorReportModel> result = [];
    result.add(
      AmmeterErrorReportModel(
        ammeter: model,
        startTime: DateTime.now(),
        duration: const Duration(hours: 1),
        electricityConsumed: (
          model.weaklyAccumulatedElectricityFlow.isNotEmpty 
          ? model.weaklyAccumulatedElectricityFlow.last.power * (Random().nextBool() ? 2.25 : 0.45)
          : 0
        ).toInt(),
        averageElectricityConsumed: (
          model.weaklyAccumulatedElectricityFlow.isNotEmpty
          ? model.weaklyAccumulatedElectricityFlow.last.power : 0
        ).toInt()
      ),
    );
    if(model.subAmmeters.isNotEmpty){
      for(AmmeterModel child in model.subAmmeters){
        result.addAll(generateFakeErrorReport(child));
      }
    }
    return result;
  }

  static AmmeterModel generateFakeData(){
    return AmmeterModel(
      ammeterId: "O000",
      name: "總覽",
      workspaceType: WorkspaceType.factory,
      label: "總覽",
      subAmmeters: <AmmeterModel>[
        AmmeterModel(
          ammeterId: "f001", 
          name: "桃園觀音廠", 
          workspaceType: WorkspaceType.factory,
          label: "觀音",
          location: "桃園",
          subAmmeters: <AmmeterModel>[
            AmmeterModel(
              ammeterId: "f001-1", 
              name: "觀音-廠務", 
              workspaceType: WorkspaceType.factoryService,
              label: "廠務",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f001-1-x",
                  name: "觀音-廠務-區域ㄧ", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f001-1-y",
                  name: "觀音-廠務-區域二", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f001-1-z",
                  name: "觀音-廠務-區域三", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
            AmmeterModel(
              ammeterId: "f001-2", 
              name: "觀音-產線", 
              workspaceType: WorkspaceType.productionLine,
              label: "產線",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f001-2-x",
                  name: "觀音-產線ㄧ", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f001-2-y",
                  name: "觀音-產線二", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f001-2-z",
                  name: "觀音-產線三", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
            AmmeterModel(
              ammeterId: "f001-3", 
              name: "觀音-其他", 
              workspaceType: WorkspaceType.others,
              label: "其他",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f001-o",
                  name: "觀音-其他", 
                  workspaceType: WorkspaceType.others,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
          ]
        ),
        AmmeterModel(
          ammeterId: "f002", 
          name: "桃園平鎮廠", 
          workspaceType: WorkspaceType.factory,
          label: "平鎮",
          location: "桃園",
          subAmmeters: <AmmeterModel>[
            AmmeterModel(
              ammeterId: "f002-1", 
              name: "平鎮-廠務", 
              workspaceType: WorkspaceType.factoryService,
              label: "廠務",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f002-1-x",
                  name: "平鎮-廠務-區域ㄧ", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f002-1-y",
                  name: "平鎮-廠務-區域二", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f002-1-z",
                  name: "平鎮-廠務-區域三", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
            AmmeterModel(
              ammeterId: "f002-2", 
              name: "平鎮-產線", 
              workspaceType: WorkspaceType.productionLine,
              label: "產線",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f002-2-x",
                  name: "平鎮-廠務-產線ㄧ", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f002-2-y",
                  name: "平鎮-廠務-產線二", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f002-2-z",
                  name: "平鎮-廠務-產線三", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
            AmmeterModel(
              ammeterId: "f002-3", 
              name: "平鎮-其他", 
              workspaceType: WorkspaceType.others,
              label: "其他",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f002-o",
                  name: "平鎮-廠務-其他", 
                  workspaceType: WorkspaceType.others,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
          ]
        ),
        AmmeterModel(
          ammeterId: "f003", 
          name: "法國廠", 
          workspaceType: WorkspaceType.factory,
          label: "法國",
          location: "法國",
          subAmmeters: <AmmeterModel>[
            AmmeterModel(
              ammeterId: "f003-1", 
              name: "法國-廠務", 
              workspaceType: WorkspaceType.factoryService,
              label: "廠務",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f003-1-x",
                  name: "區域ㄧ", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f003-1-y",
                  name: "區域二", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f003-1-z",
                  name: "區域三", 
                  workspaceType: WorkspaceType.factoryService,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
            AmmeterModel(
              ammeterId: "f003-2", 
              name: "法國-產線", 
              workspaceType: WorkspaceType.productionLine,
              label: "產線",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f003-2-x",
                  name: "產線ㄧ", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f003-2-y",
                  name: "產線二", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
                AmmeterModel(
                  ammeterId: "f002-2-z",
                  name: "產線三", 
                  workspaceType: WorkspaceType.productionLine,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
            AmmeterModel(
              ammeterId: "f003-3", 
              name: "法國-其他", 
              workspaceType: WorkspaceType.others,
              label: "其他",
              subAmmeters: <AmmeterModel>[
                // 不同區域電表分類
                AmmeterModel(
                  ammeterId: "f002-o",
                  name: "其他", 
                  workspaceType: WorkspaceType.others,
                  data: ElectricityFlowData.fakeData()
                ),
              ]
            ),
          ]
        ),
      ]
    );
  }
}
