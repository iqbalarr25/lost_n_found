import 'dart:convert';

class Post {
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

  Post(
      {this.userId,
      this.typePost,
      this.title,
      this.description,
      this.chronology,
      this.socialMediaType,
      this.socialMedia,
      this.imgUrl,
      this.date,
      this.activeStatus});

  Post.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
    return data;
  }

  static List<Post>? fromJsonList(List? list) {
    if (list == null) return null;
    return list.map((item) => Post.fromJson(item)).toList();
  }

  String postToJson(Post data) => json.encode(data.toJson());
}
