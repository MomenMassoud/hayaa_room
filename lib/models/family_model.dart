

import 'family_user_model.dart';

class FamilyModel {
  String bio;
  String name;
  String id;
  String doc;
  String join;
  String photo;
  int count=0;
  List<FamilyUserModel> users=[];
  FamilyModel(this.name,this.id,this.doc,this.bio,this.join,this.photo);
}