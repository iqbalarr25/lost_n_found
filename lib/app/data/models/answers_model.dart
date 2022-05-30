import 'user_model.dart';

class MyAnswers {
  String? id;
  String? questionId;
  String? userId;
  String? answer;
  String? statusAnswer;
  User? user;

  MyAnswers(
      {this.id,
      this.questionId,
      this.userId,
      this.answer,
      this.statusAnswer,
      this.user});

  MyAnswers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['questionId'];
    userId = json['userId'];
    answer = json['answer'];
    statusAnswer = json['statusAnswer'];
    user = json['User'] != null ? User?.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['questionId'] = questionId;
    data['userId'] = userId;
    data['answer'] = answer;
    data['statusAnswer'] = statusAnswer;
    if (user != null) {
      data['User'] = user?.toJson();
    }
    return data;
  }
}
