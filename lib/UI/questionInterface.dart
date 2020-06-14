/**
 * This interface is used to display the question when alarm is ringing
 */
import 'dart:convert';
import 'dart:io';
import 'package:crazyalarm/models/question.dart';
import 'package:crazyalarm/widgets/answer.dart';
import 'package:crazyalarm/services/questionAPI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:http/http.dart' as http;

///Call the questions from question model
Question question = Question();

class QuizPage extends StatefulWidget {
  final String getCount;
  QuizPage(this.getCount);
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> results;
  int score = 0;
  Quiz quiz;
  Color setColor;
  int len;

  ///fetch the question from open trivia database which have JSON API.
  Future<void> fetchQuestionsFromOpenDb() async {
    var response = await http.get("https://opentdb.com/api.php?amount=15&category=19&type=multiple");
    var decodeResponse = jsonDecode(response.body);
    setColor = Colors.white;
    quiz = Quiz.fromJson(decodeResponse);
    results = quiz.question;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Be Smart & Stop Alarm",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceSansPro'
        ),),
      ),
      body: RefreshIndicator(
        color: Color(0xff65D1BA),
        onRefresh: fetchQuestionsFromOpenDb,
        child: FutureBuilder(
            future: fetchQuestionsFromOpenDb(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) return errorData(snapshot);
                  return getData();
              }
              return null;
            }),
      ),

    );
  }
///error handling when the question is not populated from databse
  Padding errorData(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Error: ${snapshot.error}',
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            child: Text("Try Again"),
            onPressed: () {
              fetchQuestionsFromOpenDb();
              setState(() {});
            },
          )
        ],
      ),
    );
  }

///list view the all questions
  getData(){
    len = int.parse(widget.getCount);
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ListView.builder(
            itemCount: len,
            itemBuilder: (context, index) => Card(
              color: Colors.white,
              elevation: 0.0,
              child : new GestureDetector(
                child: ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          results[index].getQuestion,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'SourceSansPro',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  children:
                  results[index].getAllAnswers.map((m) {
                    return AnswerWidget(results, index, m,score);
                  }).toList(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () {
                if(getQuizScore() == len){
                  FlutterRingtonePlayer.stop();
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
                  exit(0);
                  print(len);
                }
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.alarm_off,size: 35.0,),
            ),
          ),
        ],
      ),
    );
  }
}

