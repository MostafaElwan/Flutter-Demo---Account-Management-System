import 'package:account_managment/common/AppUtil.dart';
import 'package:account_managment/manager/PreferencesManager.dart';
import 'package:account_managment/screens/AccountsViewer.dart';
import 'package:account_managment/screens/LoginSignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:account_managment/common/locale/localizations.dart';
import 'package:account_managment/common/locale/initialize_i18n.dart';
import 'package:account_managment/model/lov/LanguageLOV.dart';

void main() async {
  await start();
  Map<String, Map<String, String>> localizedValues = await initializeI18n();
  runApp(App(localizedValues));
}

start() async {
  await PreferencesManager.createInstance().init();
}

class App extends StatefulWidget {

  final Map<String, Map<String, String>> localizedValues;

  App(this.localizedValues);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  String _locale = PreferencesManager.createInstance().getCurrentLocale();
  onChangeLanguage() {
    setState(() {
      if (_locale == LanguageLOV.ENGLISH.shdes) {
        _locale = LanguageLOV.ARABIC.shdes;
      } else {
        _locale = LanguageLOV.ENGLISH.shdes;
      }
      PreferencesManager.createInstance().setCurrentLocale(_locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppUtil.setOnChangeLanguageListener(onChangeLanguage);
    return new MaterialApp(
        locale: Locale(_locale),
        localizationsDelegates: [
          AppLocalizationsDelegate(widget.localizedValues),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: LanguageLOV.all.map((language) => Locale(language.shdes, '')),

//        home: FirstScreen(onChangeLanguage),
    home: LoginSignUpPage(),
    );
  }
}

//class AppBody extends StatelessWidget {
//
//  final VoidCallback onChangeLanguage;
//
//  AppBody(this.onChangeLanguage);

//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text(AppLocalizations.of(context).hello),
//        ),
//        body: new Center(
//          child: new Text(AppLocalizations.of(context).greetTo('Nina')),
//        ),
//        floatingActionButton: new FloatingActionButton(
//            child: new Icon(Icons.language), onPressed: onChangeLanguage));
//  }
//}
