import 'package:crazyalarm/UI/add_alarm.dart';
import 'package:crazyalarm/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'models/alarm.dart';


void main() => runApp(AlarmApp());

class AlarmApp extends StatefulWidget {

  _AlarmAppState createState() => _AlarmAppState();
}

class _AlarmAppState extends State<AlarmApp>{

  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDay = TimeOfDay.now();
    Alarm alarm;
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/add-alarm': (context) => AddAlarm(timeOfDay.format(context),alarm,"2"),
        },
        theme: ThemeData(
            fontFamily: 'SourceSansPro',
            primaryColor: Color(0xff1B2C57),
            accentColor: Color(0xff65D1BA)
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
    );
  }
}