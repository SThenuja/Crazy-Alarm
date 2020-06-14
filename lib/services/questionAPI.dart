/// This a API class which is used to get questions from http request
/// OpenDb is the one of the REST ful  JSON API to get data from that
///

import 'package:crazyalarm/models/question.dart';

class Quiz {
  int responseCode;
  List<Question> question;
  Quiz quiz;

  Quiz({this.responseCode, this.question});

  Quiz.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    if (json['results'] != null) {
      question = new List<Question>();
      json['results'].forEach((v) {
        question.add(new Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    if (this.question != null) {
      data['results'] = this.question.map((v) => v.toJson()).toList();
    }
    return data;
  }

}