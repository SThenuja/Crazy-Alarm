/**
 * set the notifications
 * set alarm
 * list views data from firebase
 */
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crazyalarm/UI/add_alarm.dart';
import 'package:crazyalarm/UI/questionInterface.dart';
import 'package:crazyalarm/models/alarm.dart';
import 'package:crazyalarm/services/alarmAPI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';


class MyAlarm extends StatefulWidget {
  final String title ='Crazy Alarm';
  @override
  _MyAlarmPageState createState() => _MyAlarmPageState();

}
List<String> alTime = List();
class _MyAlarmPageState extends State<MyAlarm> {
  ///variable initialization
  TimeOfDay today;
  int flag =0;
  Alarm al = new Alarm();
  List<Alarm> alarm = new List();
  bool timeReached;
  Timer t;
  final String _collection = 'alarmTime';
  ///firebase initialization
  final Firestore _fireStore = Firestore.instance;

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
    ///initialize timer ring alarm
    Timer.periodic(Duration(seconds: 1), (Timer t) => fireAlarm());
  }

  ///https://pub.dev/packages/flutter_local_notifications
  ///notification initialization services codes get from flutter packages page
  void initializeNotification() async {
    androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onDidReceiveLocalNotification(
      int _id, String _ttl, String _bdy, String _payld) async {
    return CupertinoAlertDialog(
      title: Text(_ttl),
      content: Text(_bdy),
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
  Future<void> setNotification(String time) async {
    AndroidNotificationDetails android =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notdetls =
    NotificationDetails(android, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Crazy Alarm', 'Your alarm notification turn on $time', notdetls);
  }

  void _showSetNotifications(String _alarmTime) async {
    await setNotification(_alarmTime);
  }
  // ignore: missing_return
  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Theme.of(context).primaryColor ,
        child: buildBody(context),
      )
    );
  }

  /// https://codelabs.developers.google.com/codelabs/flutter-firebase/#0
  /// list views data from firebase
  Widget buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: getAlarm(),
      builder: (context,snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );

  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => alarmItem(context, data)).toList(),
    );
  }

  Widget alarmItem(BuildContext buildContext, DocumentSnapshot data){
    final record = Alarm.fromSnapshot(data);
    return Padding(
      padding: EdgeInsets.all(17.0),
      ///https://flutter.dev/docs/cookbook/gestures/dismissible
      child: new Dismissible(
        key: Key(data.documentID),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new GestureDetector(
                      child: Text(record.time, style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansPro'
                      ),),
                      onTap: (){
                       // _showNotificationsAfterSecond(record.time);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm(record.time,record,record.quizCount)),);
                      },
                    ),

                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(record.name, style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                          ),),
                        ),
                      ],
                    ),
                  ],
                ),
                CupertinoSwitch(
                  value: record.status,
                  onChanged: (bool val) {
                    setState(() {
                      updateStatus(record, val);
                      print(val);
                    });
                    if(val == true){
                      _showSetNotifications(record.time);
                    }
                  },
                  activeColor: Color(0xff65D1BA),
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            SizedBox(
              height: 1.0,
              width: double.maxFinite,
              child: Container(
                color: Colors.white30,
              ),
            )
          ],
        ),
          ///https://flutter.dev/docs/cookbook/gestures/dismissible
        onDismissed: (DismissDirection direction) {
          setState(() {
            delete(record);
          });
          // Then show a Snack bar.
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Alarm ${record.time} deleted")));
        },
        background: stackBehindDismiss()
      ),
    );
  }

  ///https://flutter.dev/docs/cookbook/gestures/dismissible
  ///dismissable widget tree delete button show
  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  getAlarmData() async {
    return await _fireStore.collection(_collection).getDocuments();
  }

  fireAlarm(){
    getAlarmData().then((val){
      for(int i =0; i <val.documents.length ; i++){
        TimeOfDay now = TimeOfDay.now();
        if (now.format(context) == val.documents[i].data["time"] && val.documents[i].data['status'] == true && flag ==0 ) {
          flag++;
          if(flag == 1){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => QuizPage(val.documents[i].data['quizCount'])),(Route<dynamic> route) => false);
            const oneSec = const Duration(seconds: 2);
            t = new Timer.periodic(oneSec, (Timer t) =>
                FlutterRingtonePlayer.playRingtone());
          }
          print(now.format(context));
          print("Alarm Ringing");
        }
        else{
          FlutterRingtonePlayer.stop();
        }

      }
    });
  }

  TimeOfDay stringToTimeOfDay(String tod) { ///https://stackoverflow.com/questions/53382971/how-to-convert-string-to-timeofday-in-flutter
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

///format TimeOfDay into DateTime
  getDateTime(TimeOfDay timeOfDay){
    final now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

}

