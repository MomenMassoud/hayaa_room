

import '../../../models/family_rank.dart';
import '../../../models/story_model.dart';

class RankUserModel {
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
  num welthDay;
  num welthWeak;
  num welthMonth;
  num welthHalfYear;
  num charmDay;
  num charmWeak;
  num charmMonth;
  num charmHalfYear;

  RankUserModel(
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
    this.level,
    this.welthDay,
    this.welthWeak,
    this.welthMonth,
    this.welthHalfYear,
    this.charmDay,
    this.charmWeak,
    this.charmMonth,
    this.charmHalfYear, {
    this.acualCountry = "",
  });

  factory RankUserModel.fromJson(Map<String, dynamic> json) {
    return RankUserModel(
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
      json['welthday'],
      json['welthweak'],
      json['welthmonth'],
      json['welthhalfyear'],
      json['charmday'],
      json['charmweak'],
      json['charmmonth'],
      json['charmhalfyear'],
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
