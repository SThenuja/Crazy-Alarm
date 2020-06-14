/**
 * This a API class which is used to get do the CRUD operations via this file
 * Below methods are used to perform CRUD in crazy alarm project
 *https://codelabs.developers.google.com/codelabs/flutter-firebase/#0
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crazyalarm/models/alarm.dart';


String collectionName= "alarmTime";
final databaseReference = Firestore.instance;

/// adding alarm details into firebase cloud store
/// https://codelabs.developers.google.com/codelabs/flutter-firebase/#0

addAlarm(String name,String time, String tone,String count, bool status){
  Alarm alarm = Alarm(name: name, time:time, tone:tone, quizCount:count, status: status);
  try{
    Firestore.instance.runTransaction((Transaction transaction)async{
      await Firestore.instance.collection(collectionName).document().setData(alarm.toJson());
    },
    );
  }catch(e){
    print(e.toString());
  }
}

/// Get alarm details from firebase cloud store
/// https://codelabs.developers.google.com/codelabs/flutter-firebase/#0
getAlarm(){
  return Firestore.instance.collection(collectionName).snapshots();
}

/// Update alarm details from firebase cloud store
update(Alarm alarm, String newTime,String count,String name){
  try{
    Firestore.instance.runTransaction((transaction)async{
      await transaction.update(alarm.reference, {'time': newTime,'quizCount':count,'name':name});
    });
  }catch(e){
    print(e.toString());
  }
}

/// Delete alarm details from firebase cloud store
/// https://codelabs.developers.google.com/codelabs/flutter-firebase/#0
delete(Alarm alarm){
  Firestore.instance.runTransaction((Transaction transaction) async{
    await transaction.delete(alarm.reference);
  },
  );
}

/// Update alarm status in firebase cloud store
/// https://codelabs.developers.google.com/codelabs/flutter-firebase/#0
updateStatus(Alarm alarm, bool newStatus){
  try{
    Firestore.instance.runTransaction((transaction)async{
      await transaction.update(alarm.reference, {'status': newStatus});
    });
  }catch(e){
    print(e.toString());
  }
}