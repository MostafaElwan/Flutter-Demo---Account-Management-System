import 'dart:async' show Future;
import 'package:account_managment/model/lov/LanguageLOV.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class AppLocalizations {

  final Map<String, Map<String, String>> localizedValues;

  AppLocalizations(this.locale, this.localizedValues);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get first_screen_app_bar => localizedValues[locale.languageCode]['first_screen_app_bar'];
  String get active_accounts_ttl => localizedValues[locale.languageCode]['active_accounts_ttl'];
  String get inactive_accounts_ttl => localizedValues[locale.languageCode]['inactive_accounts_ttl'];

  String get delete_account_ttl => localizedValues[locale.languageCode]['delete_account_ttl'];
  String get delete_account_msg => localizedValues[locale.languageCode]['delete_account_msg'];
  String get msg_acnt_deleted_dn => localizedValues[locale.languageCode]['msg_acnt_deleted_dn'];

  String get psh_dta_srvr_msg => localizedValues[locale.languageCode]['psh_dta_srvr_msg'];
  String get msg_psh_dta_srvr_dn => localizedValues[locale.languageCode]['msg_psh_dta_srvr_dn'];

  String get ftch_dta_lcl_msg => localizedValues[locale.languageCode]['ftch_dta_lcl_msg'];
  String get msg_ftch_dta_lcl_dn => localizedValues[locale.languageCode]['msg_ftch_dta_lcl_dn'];

  String get msg_no_actv_acnts => localizedValues[locale.languageCode]['msg_no_actv_acnts'];
  String get msg_no_inactv_acnts => localizedValues[locale.languageCode]['msg_no_inactv_acnts'];

  String get btn_cncl_ttl => localizedValues[locale.languageCode]['btn_cncl_ttl'];
  String get btn_acpt_ttl => localizedValues[locale.languageCode]['btn_acpt_ttl'];
  String get btn_new_hnt => localizedValues[locale.languageCode]['btn_new_hnt'];

  String get sign_out_msg => localizedValues[locale.languageCode]['sign_out_msg'];


//  greetTo(name) {
//    return localizedValues[locale.languageCode]['greetTo']
//        .replaceAll('{{name}}', name);
//  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  Map<String, Map<String, String>> localizedValues;

  AppLocalizationsDelegate(this.localizedValues);

  @override
  bool isSupported(Locale locale){
    return LanguageLOV.all.contains(LanguageLOV.fromShdes(locale.languageCode));
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        AppLocalizations(locale, localizedValues));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
