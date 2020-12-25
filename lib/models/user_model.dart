import 'dart:convert';

class UserModel {
  final String email;
  final String name;
  final String password;
  UserModel({
    this.email,
    this.name,
    this.password,
  });

  UserModel copyWith({
    String email,
    String name,
    String password,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserModel(
      email: map['email'],
      name: map['name'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(email: $email, name: $name, password: $password)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserModel &&
      o.email == email &&
      o.name == name &&
      o.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ password.hashCode;
}
