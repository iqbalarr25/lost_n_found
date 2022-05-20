import 'dart:convert';

import 'questions_model.dart';

class Post {
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

  Post(
      {this.id,
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
      this.deleteStatus});

  Post.fromJson(Map<String, dynamic> json) {
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
    return data;
  }

  static List<Post>? fromJsonList(List? list) {
    if (list == null) return null;
    return list.map((item) => Post.fromJson(item)).toList();
  }

  String postToJson(Post data) => json.encode(data.toJson());
}

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
  List<Questions>? questions;

  MyPost(
      {this.id,
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
      this.questions});

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
    if (json['Questions'] != null) {
      questions = <Questions>[];
      json['Questions'].forEach((v) {
        questions?.add(Questions.fromJson(v));
      });
    }
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
    if (questions != null) {
      data['Questions'] = questions?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
