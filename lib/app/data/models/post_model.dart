import 'dart:convert';

import 'questions_model.dart';
import 'user_model.dart';

class MyPost {
  String? id;
  String? userId;
  String? typePost;
  String? title;
  String? description;
  String? chronology;
  String? socialMediaType;
  String? socialMedia;
  List<String>? imgUrl;
  String? date;
  bool? activeStatus;
  bool? deleteStatus;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<MyQuestions>? questions;
  String? hero;

  MyPost({
    this.id,
    this.userId,
    this.typePost,
    this.title,
    this.description,
    this.chronology,
    this.socialMediaType,
    this.socialMedia,
    this.imgUrl,
    this.date,
    this.activeStatus,
    this.deleteStatus,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.questions,
    this.hero,
  });

  MyPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    typePost = json['typePost'];
    title = json['title'];
    description = json['description'];
    chronology = json['chronology'];
    socialMediaType = json['socialMediaType'];
    socialMedia = json['socialMedia'];
    imgUrl = json['imgUrl'].cast<String>();
    date = json['date'];
    activeStatus = json['activeStatus'];
    deleteStatus = json['deleteStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['User'] != null ? User?.fromJson(json['User']) : null;
    if (json['Questions'] != null) {
      questions = <MyQuestions>[];
      json['Questions'].forEach((v) {
        questions?.add(MyQuestions.fromJson(v));
      });
    }
    hero = imgUrl![0];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['typePost'] = typePost;
    data['title'] = title;
    data['description'] = description;
    data['chronology'] = chronology;
    data['socialMediaType'] = socialMediaType;
    data['socialMedia'] = socialMedia;
    data['imgUrl'] = imgUrl;
    data['date'] = date;
    data['activeStatus'] = activeStatus;
    data['deleteStatus'] = deleteStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['User'] = user?.toJson();
    }
    if (questions != null) {
      data['Questions'] = questions?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<MyPost>? fromJsonList(List? list) {
    if (list == null) return null;
    return list.map((item) => MyPost.fromJson(item)).toList();
  }

  String postToJson(MyPost data) => json.encode(data.toJson());
}
