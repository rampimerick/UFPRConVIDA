import 'package:flutter/cupertino.dart';
import 'package:ufpr_convida_2/app/screens/detailed_event_screen/detailed_event_widget.dart';
import 'package:ufpr_convida_2/app/screens/login_screen/login_widget.dart';
import 'package:ufpr_convida_2/app/screens/main_screen/main_widget.dart';
import 'package:ufpr_convida_2/app/screens/map_screen/map_widget.dart';
import 'package:ufpr_convida_2/app/screens/new_event_screen/new_event_widget.dart';
import 'package:ufpr_convida_2/app/screens/profile_screen/profile_widget.dart';
import 'package:ufpr_convida_2/app/screens/settings_screen/settings_widget.dart';
import 'package:ufpr_convida_2/app/screens/signup_screen/signup_widget.dart';
import 'package:ufpr_convida_2/app/screens/splash_screen/splash_widget.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => SplashScreen(),
  '/main': (context) => MainWidget(),
  '/map': (context) => MapWidget(),
  '/profile':(context) => ProfileWidget(),
  '/settings': (context) => SettingsWidget(),
  '/login': (context) => LoginWidget(),
  '/signup': (context) => SignUpWidget(),
  '/event' : (context) => DetailedEventWidget(),
  '/new-event' : (context) => NewEventWidget(),
};