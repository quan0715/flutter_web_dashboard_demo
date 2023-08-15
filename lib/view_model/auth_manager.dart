import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthManager extends ChangeNotifier{
  bool _isLogin = false;
  bool _isLoading = false;
  bool? _isError;
  // debug account
  String? account = "nickyin@tw.ibm.com";
  String? password = "123456";
  // String? account;
  // String? password;
  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;
  bool? get isError => _isError;
  String? accountValidator(value) => account != null && account!.isNotEmpty ? null : "帳號不得留空";
  String? passwordValidator(value) => password != null && password!.isNotEmpty ? null : "密碼不得留空";

  void setAccount(String? value){
    account = value;
    // notifyListeners();
  }

  void setPassword(String? value){
    password = value;
    // notifyListeners();
  }
  
  Future<void> login() async{
    debugPrint("sign in $account $password");
    _isLoading = true;
    notifyListeners();
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: account!, password: password!);
      _isLogin = true;
      debugPrint("login success");
      notifyListeners();
    } 
    catch(e){
      debugPrint("login: $e");
      _isLogin = false;
      _isError = true;
      notifyListeners();
      rethrow;
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async{
    _isLoading = true;
    notifyListeners();
    try{
      await FirebaseAuth.instance.signOut();
      _isLogin = false;
      debugPrint("sign out success");
      notifyListeners();
    }catch(e){
      _isLogin = true;
      debugPrint("sign out: $e");
      notifyListeners();
      rethrow;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}