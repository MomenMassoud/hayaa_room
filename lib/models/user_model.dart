

import 'package:hayaa_main/models/story_model.dart';

import 'family_rank.dart';

class UserModel {
  String bio;
  String birthdate;
  String coin;
  String daimond;
  String devicetoken;
  String country;
  String acualCountry;
  String exp;
  String gender;
  String id;
  String lang;
  String level;
  String name;
  String phonenumber;
  String photo;
  String seen;
  String type;
  String vip;
  String email;
  int sizeFirends = 0;
  int sizefans = 0;
  int sizevisitors = 0;
  int sizefollowing = 0;
  late String exp2;
  late String level2;
  String docID = "";
  late String myfamily;
  late String familytype;
  List<FamilyRankModel> familyRank = [];
  List<StoryModel> storys = [];
  late List<dynamic> wearingBadges = [];
  int valueRank = 0;
  String myroom = "";
  UserModel(
    this.email,
    this.name,
    this.gender,
    this.photo,
    this.id,
    this.phonenumber,
    this.devicetoken,
    this.daimond,
    this.vip,
    this.bio,
    this.seen,
    this.lang,
    this.country,
    this.type,
    this.birthdate,
    this.coin,
    this.exp,
    this.level, {
    this.acualCountry = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['email'],
      json['name'],
      json['gender'],
      json['photo'],
      json['id'],
      json['phonenumber'],
      json['devicetoken'],
      json['daimond'],
      json['vip'],
      json['bio'],
      json['seen'].toString(),
      json['lang'],
      json['country'],
      json['type'],
      json['birthdate'],
      json['coin'],
      json['exp'],
      json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'gender': gender,
      'photo': photo,
      'id': id,
      'phonenumber': phonenumber,
      'devicetoken': devicetoken,
      'daimond': daimond,
      'vip': vip,
      'bio': bio,
      'seen': seen,
      'lang': lang,
      'country': country,
      'type': type,
      'birthdate': birthdate,
      'coin': coin,
      'exp': exp,
      'level': level,
    };
  }
}
