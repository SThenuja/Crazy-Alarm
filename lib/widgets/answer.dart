/**
 * this widget is used to populate the answers
 */
import 'package:crazyalarm/models/question.dart';
import 'package:flutter/material.dart';

int getScore =0;
// ignore: must_be_immutable
class AnswerWidget extends StatefulWidget {
  final List<Question> results;
  final int index;
  final String m;
  int score;
  AnswerWidget(this.results, this.index, this.m, this.score);

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  Color setColor = Colors.black;
  String _correctAnswerValue = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(17.0),
        child: ListTile(
          title: RadioListTile(
            groupValue: _correctAnswerValue,
            value: widget.m,
            activeColor: setColor,
            title: Text(widget.m,
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
            onChanged: (value){
              setState(() {
                if (widget.m == widget.results[widget.index].getCorrectAnswer) {
                  _correctAnswerValue = value;
                  print(_correctAnswerValue);
                  getScore = getScore+1;
                  setColor = Colors.green;

                } else {
                  _correctAnswerValue = value;
                  setColor = Colors.red;
                }
              });
              widget.score = getScore;
              //print(widget.score );
            },
          ),
        )
    );

  }


}
int getQuizScore(){
  return getScore;
}