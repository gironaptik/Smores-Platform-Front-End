import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User {
  UserKey key;
  String username;
  String avatar;
  String role;
  int points;

  User({this.key, this.username, this.avatar, this.role, this.points});

  User.fromJson(Map<String, dynamic> json) {
    key = json['key'] != null ? new UserKey.fromJson(json['key']) : null;
    username = json['username'];
    avatar = json['avatar'];
    role = json['role'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.key != null) {
      data['key'] = this.key.toJson();
    }
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['points'] = this.points;
    return data;
  }
}

class UserKey {
  String smartspace;
  String email;

  UserKey({this.smartspace, this.email});

  UserKey.fromJson(Map<String, dynamic> json) {
    smartspace = json['smartspace'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['smartspace'] = this.smartspace;
    data['email'] = this.email;
    return data;
  }
}
