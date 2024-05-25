class VipModel {
  final String id;
  final String joinFrame;
  final String joinVideo;
  final String nameColor;
  final String vipBadge;
  final String vedioType;

  VipModel(
      {required this.id,
      required this.joinFrame,
      required this.joinVideo,
      required this.nameColor,
      required this.vipBadge,
      required this.vedioType});

  factory VipModel.fromJson(Map<String, dynamic> json) {
    return VipModel(
      id: json['id'],
      joinFrame: json['joinframe'],
      joinVideo: json['joinvedio'],
      nameColor: json['namecolor'],
      vipBadge: json['vipbadge'],
      vedioType: json['vediotype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'joinframe': joinFrame,
      'joinvideo': joinVideo,
      'namecolor': nameColor,
      'vipbadge': vipBadge,
      'vediotype': vedioType,
    };
  }
}
