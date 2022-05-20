class Answers {
  String? id;
  String? questionId;
  String? userId;
  String? answer;
  String? statusAnswer;

  Answers(
      {this.id, this.questionId, this.userId, this.answer, this.statusAnswer});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['questionId'];
    userId = json['userId'];
    answer = json['answer'];
    statusAnswer = json['statusAnswer'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['questionId'] = questionId;
    data['userId'] = userId;
    data['answer'] = answer;
    data['statusAnswer'] = statusAnswer;
    return data;
  }
}
