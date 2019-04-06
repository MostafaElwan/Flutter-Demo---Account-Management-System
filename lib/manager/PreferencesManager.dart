import 'package:account_managment/dao/AccountDAO.dart';
import 'package:account_managment/model/Account.dart';
import 'package:account_managment/model/lov/LanguageLOV.dart';
import 'package:account_managment/model/lov/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {

  static PreferencesManager _instance;
  static SharedPreferences prefs;

  PreferencesManager.createInstance();

  factory PreferencesManager() {
    if(_instance == null)
      _instance = PreferencesManager.createInstance();

    return _instance;
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setCurrentLocale(String lang) async {
    prefs.setString(Preference.LANG.toString(), lang);
  }

  String getCurrentLocale() {
    return prefs.getString(Preference.LANG.toString()) ?? LanguageLOV.ENGLISH.shdes;
  }

  void setCurrentViewMode(FirstScreenView fsv) async {
    prefs.setInt(Preference.VIEW.toString(), fsv.index);
  }

  FirstScreenView getCurrentViewMode() {
    return FirstScreenView.values[prefs.getInt(Preference.VIEW.toString()) ?? 0];
  }

  void setUser(String email) {
    prefs.setString(Preference.USER.toString(), email);
  }

  String getUser() {
    return prefs.getString(Preference.USER.toString()) ?? null;
  }

}