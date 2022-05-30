class User {
  String? id;
  String? email;
  String? name;
  String? password;
  String? role;
  dynamic nim;
  dynamic phone;
  dynamic imgUrl;

  User(
      {this.id,
      this.email,
      this.name,
      this.password,
      this.role,
      this.nim,
      this.phone,
      this.imgUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    role = json['role'];
    nim = json['nim'];
    phone = json['phone'];
    imgUrl = json['imgUrl'];
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
    return data;
  }
}
