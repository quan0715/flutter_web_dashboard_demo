import 'package:flutter/material.dart';
import 'package:web_dashboard/models/state.dart';

class BaseViewModel extends ChangeNotifier{
  
  LoadingState loadingState = LoadingState.free;

  void init(){
    setLoadingState(LoadingState.free);
    notifyListeners();
  }
  
  void setLoadingState(LoadingState state){
    loadingState = state;
    notifyListeners();
  }

  void refreshPage(){
    notifyListeners();
  }
  
}