import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarActionLOV {

  final String title;
  final IconData icon;

  const AppBarActionLOV._internal(this.title, this.icon);

  static const VIEW_SWITCH = const AppBarActionLOV._internal("Change View", Icons.view_quilt);
  static const LANGUAGE_SWITCH = const AppBarActionLOV._internal("Change Language", Icons.language);
  static const PUSH_CLOUDY_DATA = const AppBarActionLOV._internal("Push Data", Icons.arrow_upward);
  static const FETCH_CLOUDY_DATA = const AppBarActionLOV._internal("Fetch Data", Icons.arrow_downward);
  static const SIGN_OUT = const AppBarActionLOV._internal("Sign Out", Icons.exit_to_app);

  static List<AppBarActionLOV> get firstScreenActions => [
    VIEW_SWITCH,
    LANGUAGE_SWITCH,
    PUSH_CLOUDY_DATA,
    FETCH_CLOUDY_DATA,
    SIGN_OUT,
  ];
}