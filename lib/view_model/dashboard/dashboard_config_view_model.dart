import 'package:flutter/material.dart';
import 'package:web_dashboard/db/elastic_search.dart';
import 'package:web_dashboard/models/data/config.dart';
import 'package:web_dashboard/models/data/state.dart';
import 'package:web_dashboard/models/repo/config_repo_model.dart';
import 'package:web_dashboard/view_model/base_view_model.dart';

class DashboardConfigViewModel extends BaseViewModel {

  DateTime _lastUpdate = DateTime.now();
  DateTime get lastUpdate => _lastUpdate;
  ConfigRepoModel? configModel = ConfigRepoModel.getInstance();

  final List<int> _scadaCycleTimeOption = const [10, 15, 20, 30 ,60]; 
  List<int> get scadaCycleTimeOption => _scadaCycleTimeOption;

  // SCADA Cycle Interval 監測週期
  // int _cycleTime = 10;
  int get cycleTime => configModel?.scadaIntervalPerMin ?? 10;
  set cycleTime(int value){
    configModel!.scadaIntervalPerMin = value;
    notifyListeners();
  }

  // Rate Type 尖峰時段類型
  RateType get rateType => configModel?.priceRateType ?? RateType.fixed;
  set rateType(RateType value){
    configModel!.priceRateType = value;
    notifyListeners();
  }

  // Rate Section Type 尖峰時段分段方式
  RateSectionType get section => configModel?.priceRateSectionType ?? RateSectionType.twoStep;
  set section(RateSectionType value){
    configModel?.priceRateSectionType = value;
    notifyListeners();
  }
  
  // Rate Voltage Type 電量分類
  RateVoltageType get voltage => configModel?.priceRateVoltageType ?? RateVoltageType.hv;
  set voltage(RateVoltageType value){
    configModel?.priceRateVoltageType = value;
    notifyListeners();
  }

  // Contract Capacity 契約容量
  int get contractCapacity => configModel?.priceRateContractCapacity ?? 10000;
  set contractCapacity(int value){
    configModel?.priceRateContractCapacity = value;
    notifyListeners();
  }

  void onReset(){
    configModel?.scadaIntervalPerMin = 10;
    configModel?.priceRateType = RateType.fixed;
    configModel?.priceRateSectionType = RateSectionType.twoStep;
    configModel?.priceRateVoltageType = RateVoltageType.hv;
    configModel?.priceRateContractCapacity = 10000;
    notifyListeners();
  }

  Future<void> onSave() async{
    setLoadingState(LoadingState.loading);
    try{
      debugPrint(configModel.toString());
      await ElasticSearchClient.configClient().post(configModel!);
      _lastUpdate = DateTime.now();
    } catch(e){
      debugPrint(e.toString());
      setLoadingState(LoadingState.error);
    } finally{
      setLoadingState(LoadingState.free);
    }
  }

  @override
  Future<void> init() async {
    setLoadingState(LoadingState.loading);
    configModel = (await ElasticSearchClient.configClient().search()).first;
    debugPrint(configModel.toString());
    _lastUpdate = DateTime.now();
    setLoadingState(LoadingState.free);
  }
}