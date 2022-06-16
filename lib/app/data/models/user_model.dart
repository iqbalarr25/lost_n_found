class User {
  String? id;
  String? email;
  String? name;
  String? password;
  String? role;
  String? nim;
  String? phone;
  String? imgUrl;
  int? totalPost;

  User({
    this.id,
    this.email,
    this.name,
    this.password,
    this.role,
    this.nim,
    this.phone,
    this.imgUrl,
    this.totalPost,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    role = json['role'];
    nim = json['nim'];
    phone = json['phone'];
    imgUrl = json['imgUrl'];
    totalPost = json['totalPost'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['role'] = role;
    data['nim'] = nim;
    data['phone'] = phone;
    data['imgUrl'] = imgUrl;
    data['totalPost'] = totalPost;
    return data;
  }
}
