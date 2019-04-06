import 'package:flutter/material.dart';

abstract class AppUtil {

  static void Function() _onChangeLanguageListener;

  static void setOnChangeLanguageListener(Function() ocll) => _onChangeLanguageListener = ocll;

  static Function() get getOnChangeLanguageListener => _onChangeLanguageListener;

  static void onLoading(context, msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(msg),
                Container(
                  constraints: BoxConstraints(
                      maxHeight: 20.0,
                      minHeight: 15.0
                  ),
                ),
                LinearProgressIndicator(),
              ],
            ),
          )
        );
      },
    );
  }

  static void showAlertDialog(BuildContext ctxt, String title, String message, String cancelCaption, String acceptCaption, acceptAction) {
    showDialog(
      context: ctxt,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(cancelCaption),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text(acceptCaption),
              onPressed: () {
                Navigator.of(context).pop();
                acceptAction();
              },
            )
          ],
        );
      },
    );
  }

  static void showMessageBar(BuildContext _scaffoldContext, String msg) {
    Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(content: Text(msg)));
  }

}