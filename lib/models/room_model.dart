class RoomModels {
  String bio;
  String car;
  String cartype;
  String doc;
  String gift;
  String gifttype;
  String id;
  String owner;
  String password;
  String seat;
  String wallpaper;
  String photo;

  RoomModels(
    this.id,
    this.doc,
    this.gift,
    this.gifttype,
    this.cartype,
    this.wallpaper,
    this.password,
    this.owner,
    this.bio,
    this.car,
    this.seat,
    this.photo,
  );

  factory RoomModels.fromJson(Map<String, dynamic> json) {
    return RoomModels(
      json['id'] as String,
      json['doc'] as String,
      json['gift'] as String,
      json['gifttype'] as String,
      json['cartype'] as String,
      json['wallpaper'] as String,
      json['password'] as String,
      json['owner'] as String,
      json['bio'] as String,
      json['car'] as String,
      json['seat'] as String,
      json['photo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doc': doc,
      'gift': gift,
      'gifttype': gifttype,
      'cartype': cartype,
      'wallpaper': wallpaper,
      'password': password,
      'owner': owner,
      'bio': bio,
      'car': car,
      'seat': seat,
      'photo': photo,
    };
  }
}
