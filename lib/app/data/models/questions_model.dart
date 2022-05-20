import 'answers_model.dart';

class Questions {
  String? id;
  String? userId;
  String? postId;
  String? typeQuestion;
  String? question;
  String? statusQuestion;
  String? createdAt;
  String? updatedAt;
  List<Answers>? answers;

  Questions(
      {this.id,
      this.userId,
      this.postId,
      this.typeQuestion,
      this.question,
      this.statusQuestion,
      this.createdAt,
      this.updatedAt,
      this.answers});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postId = json['postId'];
    typeQuestion = json['typeQuestion'];
    question = json['question'];
    statusQuestion = json['statusQuestion'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['Answers'] != null) {
      answers = <Answers>[];
      json['Answers'].forEach((v) {
        answers?.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['postId'] = postId;
    data['typeQuestion'] = typeQuestion;
    data['question'] = question;
    data['statusQuestion'] = statusQuestion;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (answers != null) {
      data['Answers'] = answers?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
