import 'dart:convert';
import 'dart:async' show Future;
import 'package:account_managment/model/lov/LanguageLOV.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadJsonFromAsset(language) async {
  return await rootBundle.loadString('assets/i18n/' + language + '.json');
}

Map<String, String> convertValueToString(obj) {
  Map<String, String> result = {};
  obj.forEach((key, value) {
    result[key] = value.toString();
  });
  return result;
}

Future<Map<String, Map<String, String>>> initializeI18n() async {
  Map<String, Map<String, String>> values = {};
  for (LanguageLOV language in LanguageLOV.all) {
    Map<String, dynamic> translation =
    json.decode(await loadJsonFromAsset(language.shdes));
    values[language.shdes] = convertValueToString(translation);
  }
  return values;
}
