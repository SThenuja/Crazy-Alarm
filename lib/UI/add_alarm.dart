/**
 * This is an add alarm page.
 *
 */
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crazyalarm/models/alarm.dart';
import 'package:crazyalarm/services/alarmAPI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';



// ignore: must_be_immutable
class AddAlarm extends StatefulWidget {
  Alarm alarm;
  String time;
  String quizCount;
  AddAlarm(this.time,this.alarm,this.quizCount);
  _AddAlarmState createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  final databaseReference = Firestore.instance;
  String qt;
  TimeOfDay _selectedTime;
  ValueChanged<TimeOfDay> selectTime;
  bool timeReached = false;
  var snackBar;
  int _currentQuizCount;
  bool _isChecked = true;
  String status = 'test';
  TextEditingController textEditingController = new TextEditingController();
  bool buttonFlag;
  Timer t;
  TimeOfDay getTimeFromWidget;

  ///https://pub.dev/packages/flutter_local_notifications
  ///notification initialization services codes get from flutter packages page
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;


  @override
  void initState() {
    super.initState();
    getTimeFromWidget = stringToTimeOfDay(widget.time);
    _selectedTime = getTimeFromWidget;
    _currentQuizCount = int.parse(widget.quizCount);
    if  (textEditingController.text == "") {
      setState(() {
        textEditingController.text = "Alarm";
      });
    }
    initializeNotification();
  }

  ///https://pub.dev/packages/flutter_local_notifications
  ///notification initialization services codes get from flutter packages page
  void initializeNotification() async {
    androidInitializationSettings = AndroidInitializationSettings('@mipmap/alarm_ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  ///https://pub.dev/packages/flutter_local_notifications
  ///notification initialization services codes get from flutter packages page
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  ///https://pub.dev/packages/flutter_local_notifications
  ///notification initialization services codes get from flutter packages page
  Future<void> setNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Crazy Alarm', 'Your alarm set on ${_selectedTime.format(context)}', notificationDetails);
  }

  void _showAlarmNotifications() async {
    await setNotification();
  }

  TimeOfDay stringToTimeOfDay(String tod) { ///https://stackoverflow.com/questions/53382971/how-to-convert-string-to-timeofday-in-flutter
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  //notification
  // ignore: missing_return
  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
  }


  //format TimeOfDay into DateTime
  getDateTime(TimeOfDay timeOfDay){
    final now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B2C57),
      appBar: AppBar(
        backgroundColor: Color(0xff1B2C57),
        title: Column(
          children: <Widget>[
            Text('Add alarm', style: TextStyle(
              color: Color(0xff65D1BA),
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ))
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0,),
              new GestureDetector(
                child: Text(_selectedTime.format(context), style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
                onTap: () {
                  _selectTime(context);
                },
              ),
              SizedBox(height: 40.0,),
              ListTile(
                leading: Icon(Icons.repeat, color: Colors.white,size: 25.0),
                title: Text('Repeat', style: TextStyle(color: Colors.white,fontSize: 25.0)),
                onTap: (){
                  createDialog(context);
                },
              ),
             SizedBox(height: 20.0,),
              SizedBox(height: 2.0, child: Container(color: Colors.white30,),),
              ListTile(
                leading: Icon(Icons.add_circle_outline, color: Colors.white,size: 25.0),
                title: Text('Quiz Count'+' '+'${_currentQuizCount.toString()}', style: TextStyle(color: Colors.white,fontSize: 25.0 )),
                onTap: (){
                  _showIntDialog();
                },
              ),
              SizedBox(height: 20.0,),
              SizedBox(height: 2.0, child: Container(color: Colors.white30,),),
              ListTile(
                leading: Icon(Icons.label, color: Colors.white, size: 25.0),
                title: Text(textEditingController.text, style: TextStyle(color: Colors.white, fontSize: 25.0)),
                onTap: (){
                  _alarmName();
                },
              ),
              SizedBox(height: 20.0,),
              SizedBox(height: 2.0, child: Container(color: Colors.white30,),),
            ],
          ),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlarmNotifications();
          if(widget.time == TimeOfDay.now().format(context)){
            addAlarm(textEditingController.text, _selectedTime.format(context), "default", _currentQuizCount.toString(),true);
            Navigator.of(context).pop();
          }
          else{
            update(widget.alarm, _selectedTime.format(context),_currentQuizCount.toString(),textEditingController.text);
             snackBar = SnackBar(
                content: Text("Alarm was updated to ${_selectedTime.format(context)}"),
            );
            Navigator.of(context).pop();
          }

        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.alarm_on,
          size: 60.0,
          color: Colors.white,
        ),
      )
    );
  }

  // Pick the alarm time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =  await showTimePicker(
      context: context, 
      initialTime: _selectedTime
    );
    setState(() {
      _selectedTime = picked;
    });
  }



  ///show dialog box for select quiz count
  Future _showIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 2,
          maxValue: 20,
          initialIntegerValue: _currentQuizCount,
        );
      },
    ).then((int value) {
      if (value != null) {
        setState(() {
          _currentQuizCount = value;
          print(_currentQuizCount);
        });
      }
    });
  }

  ///Show alert box to set alarm name
  _alarmName() async {
    await showDialog<String>(
      context: context,
      // ignore: deprecated_member_use
      child:  new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Alarm Name', hintText: 'eg. Wake up'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('ADD'),
              onPressed: () {
                Navigator.of(context).pop(textEditingController.text);
              })
        ],
      ),
    );
  }

  ///create dialog box for set the alarm in repeat type
  Future<String> createDialog(BuildContext context){
    final _formKey = GlobalKey<FormState>();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Set Alarm'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(4.0),
                child: CheckboxListTile(
                  title: Text("Every Sunday"),
                  value: false,
                  onChanged: (val) {
                      setState(() {
                        _isChecked = val;
                      });
                    },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: CheckboxListTile(
                  title: Text("Every Monday"),
                  value: _isChecked,
                  onChanged: (val) {
                    setState(() {
                      _isChecked = val;
                    });
                  }
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: CheckboxListTile(
                  title: Text("Every Tuesday"),
                  value: false,
                  onChanged: (val) {
                    setState(() {
                      _isChecked = val;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: CheckboxListTile(
                  title: Text("Every Wednesday"),
                  value: _isChecked,
                  onChanged: (val) {
                    setState(() {
                      _isChecked = val;
                    });
                  },
                  //child: new Text("Quiz Count $_currentIntValue"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: CheckboxListTile(
                  title: Text("Every Thursday"),
                  value: false,
                  onChanged: (val) {
                    setState(() {
                      _isChecked = true;
                    });
                  },
                  //child: new Text("Quiz Count $_currentIntValue"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: CheckboxListTile(
                  title: Text("Every Friday"),
                  value: false,
                  onChanged: (val) {
                    setState(() {
                      _isChecked = true;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: CheckboxListTile(
                  title: Text("Every Saturday"),
                  value: _isChecked,
                  onChanged: (val) {
                    setState(() {
                      _isChecked = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        //controller: textEditingController,
      );
    });
  }
}
