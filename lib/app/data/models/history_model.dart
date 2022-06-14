import 'post_model.dart';

class History {
  List<MyPost>? followingFoundPosts;
  List<MyPost>? followingLostPosts;
  List<MyPost>? ownLostPosts;
  List<MyPost>? ownFoundPosts;

  History(
      {this.followingFoundPosts,
      this.followingLostPosts,
      this.ownLostPosts,
      this.ownFoundPosts});

  History.fromJson(Map<String, dynamic> json) {
    if (json['followingFoundPosts'] != null) {
      followingFoundPosts = <MyPost>[];
      json['followingFoundPosts'].forEach((v) {
        followingFoundPosts?.add(MyPost.fromJson(v));
      });
    }
    if (json['followingLostPosts'] != null) {
      followingLostPosts = <MyPost>[];
      json['followingLostPosts'].forEach((v) {
        followingLostPosts?.add(MyPost.fromJson(v));
      });
    }
    if (json['ownLostPosts'] != null) {
      ownLostPosts = <MyPost>[];
      json['ownLostPosts'].forEach((v) {
        ownLostPosts?.add(MyPost.fromJson(v));
      });
    }
    if (json['ownFoundPosts'] != null) {
      ownFoundPosts = <MyPost>[];
      json['ownFoundPosts'].forEach((v) {
        ownFoundPosts?.add(MyPost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (followingFoundPosts != null) {
      data['followingFoundPosts'] =
          followingFoundPosts?.map((v) => v.toJson()).toList();
    }
    if (followingLostPosts != null) {
      data['followingLostPosts'] =
          followingLostPosts?.map((v) => v.toJson()).toList();
    }
    if (ownLostPosts != null) {
      data['ownLostPosts'] = ownLostPosts?.map((v) => v.toJson()).toList();
    }
    if (ownFoundPosts != null) {
      data['ownFoundPosts'] = ownFoundPosts?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
