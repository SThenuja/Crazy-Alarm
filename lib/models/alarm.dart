/**
 * This a model class for storing alarm details in firebase cloud store
 * Model class is ued to map the class into cloud store.
 * Alarm is a one of the model classes.
 * this file format  is referred from CTSE lab 06
 * https://codelabs.developers.google.com/codelabs/flutter-firebase/#0
 */
import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
   String name;
   String time;
   String tone;
   String quizCount;
   bool status;
   DocumentReference reference;

  Alarm({this.name,this.time,this.tone,this.quizCount,this.status});

  ///https://codelabs.developers.google.com/codelabs/flutter-firebase/#0
  Alarm.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        time = map['time'],
        tone = map['tone'],
        quizCount = map['quizCount'],
        status = map['status'];

  Alarm.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$time:$tone:$quizCount:$status>";
  toJson() {
    return {'name': name,
            'time':time,
            'tone': tone,
            'quizCount': quizCount,
            'status': status};
 }
}