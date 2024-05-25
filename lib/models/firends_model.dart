class FriendsModel {
  String id;
  String name;
  String gender;
  String email;
  String phonenumber;
  String photo;
  String docID;
  late String bio;
  FriendsModel(
    this.email,
    this.id,
    this.docID,
    this.photo,
    this.name,
    this.phonenumber,
    this.gender,
  );

  factory FriendsModel.fromJson(Map<String, dynamic> json) {
    return FriendsModel(
      json['email'],
      json['id'],
      json['doc'],
      json['photo'],
      json['name'],
      json['phonenumber'],
      json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'id': id,
      'docID': docID,
      'photo': photo,
      'name': name,
      'phonenumber': phonenumber,
      'gender': gender,
    };
  }
}
