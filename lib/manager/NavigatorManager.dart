import 'package:account_managment/model/Account.dart';
import 'package:account_managment/screens/AccountsViewer.dart';
import 'package:account_managment/screens/AccountDetailsEditor.dart';
import 'package:account_managment/screens/LoginSignUpPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorManager {

  static NavigatorManager _instance;

  NavigatorManager.createInstance();

  factory NavigatorManager() {
    if(_instance == null)
      _instance = NavigatorManager.createInstance();

    return _instance;
  }

  back(BuildContext context) {
    Navigator.of(context).pop();
  }

  goToLoginScreen(BuildContext context) {
    Future f = Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context){
          return LoginSignUpPage();
        })
    );
  }

  goToAccountsViewer(BuildContext context, [Function() onPageReturn]) {
    Future f = Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context){
          return AccountsViewer();
        })
    );

    _registerOnPageReturn(f, onPageReturn);
  }

  goToAccountDetailsEditor(BuildContext context, Account a, [Function() onPageReturn]) {
    var f =  Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return AccountDetailsEditor(account: a);
        })
    );

    _registerOnPageReturn(f, onPageReturn);
  }

  _registerOnPageReturn(Future f, Function() onPageReturn) {
    if(onPageReturn != null) {
      f.then((val) async {
        WidgetsBinding.instance.addPostFrameCallback((_) => onPageReturn());
      });
    }
  }


}