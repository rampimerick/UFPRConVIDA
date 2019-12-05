import 'package:flutter/material.dart';
import 'package:ufpr_convida_2/app/screens/splash_screen/splash_widget.dart';
import 'package:ufpr_convida_2/app/shared/routes/routes.dart';
import 'package:ufpr_convida_2/app/shared/theme/blue_theme.dart';

import 'map_screen/map_widget.dart';

class AppWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Tira a fitinha de Debug
      debugShowCheckedModeBanner: false,
      title: "UFPRConVIDA",
      theme: blueTheme,
      initialRoute: '/',
      routes: routes
    );
  }
}
