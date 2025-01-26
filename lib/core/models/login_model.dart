class LoginModel {
  UserLogin? user;
  String? token;

  LoginModel({this.user, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserLogin.fromJson(json['user']) : null;
    token = json['token'];
  }
}

class UserLogin {
  int? id;
  String? name;
  String? email;

  UserLogin({this.id, this.name, this.email});

  UserLogin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }
}
