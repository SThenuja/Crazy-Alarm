// ignore: slash_for_doc_comments
/**
 * This a model class for populate questions when alarm alarm is ringing
 * Model class is ued to map the class into data store.
 * Question is a one of the model classes.
 */

class Question {
  String getQuestion;
  String getCorrectAnswer;
  List<String> getAllAnswers;

  Question({
    this.getQuestion,
    this.getCorrectAnswer,
  });

  Question.fromJson(Map<String, dynamic> json) {
    getQuestion = json['question'];
    getCorrectAnswer = json['correct_answer'];
    getAllAnswers = json['incorrect_answers'].cast<String>();
    getAllAnswers.add(getCorrectAnswer);
    getAllAnswers.shuffle();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.getQuestion;
    data['correct_answer'] = this.getCorrectAnswer;
    data['incorrect_answers'] = this.getAllAnswers;
    return data;
  }

}