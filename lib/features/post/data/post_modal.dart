class PostModal {
  final String ownerEmail;
  final String ownerName;
  final String ownerPhoto;
  String photo;
  String text;
  final String day;
  final String month;
  final String year;
  Map<String, LikeModal> likes = {};
  // Map<String, CommentModel> comments;
  int likesCounter;
  int commetnCounter;
  bool followButton;
  late int indexLike;

  PostModal(
      {required this.ownerEmail,
      required this.ownerName,
      required this.ownerPhoto,
      this.photo = "",
      this.text = "",
      required this.day,
      required this.month,
      required this.year,
      this.likes = const {},
      // this.comments = const {},
      this.likesCounter = 0,
      this.commetnCounter = 0,
      this.followButton = false,
      this.indexLike = 0});

  factory PostModal.fromJson(Map<String, dynamic> json) {
    return PostModal(
      ownerEmail: json['ownerEmail'],
      ownerName: json['ownerName'],
      ownerPhoto: json['ownerPhoto'],
      photo: json['photo'] ?? "",
      text: json['text'] ?? "",
      day: json['day'],
      month: json['month'],
      year: json['year'],
      likes: (json['likes'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, LikeModal.fromJson(value)),
          ) ??
          {},
      // comments: (json['comments'] as Map<String, dynamic>?)?.map(
      //       (key, value) => MapEntry(key, CommentModel.fromJson(value)),
      //     ) ??
      //     {},
      likesCounter: json['likesCounter'] ?? 0,
      commetnCounter: json['commentCounter'] ?? 0,
      followButton: json['followButton'] ?? false,
      indexLike: json['indexLike'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerEmail': ownerEmail,
      'ownerName': ownerName,
      'ownerPhoto': ownerPhoto,
      'photo': photo,
      'text': text,
      'day': day,
      'month': month,
      'year': year,
      'likes': likes.map((key, value) => MapEntry(key, value.toJson())),
      // 'comments': comments.map((key, value) => MapEntry(key, value.toJson())),
      'likesCounter': likesCounter,
      'commentCounter': commetnCounter,
      'followButton': followButton,
      'indexLike': indexLike,
    };
  }
}

class LikeModal {
  final String email;
  final String name;
  final String photo;
  late String id;
  bool like = false;
  LikeModal({required this.email, required this.name, required this.photo});

  factory LikeModal.fromJson(Map<String, dynamic> json) {
    return LikeModal(
      email: json['email'],
      name: json['name'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'photo': photo,
    };
  }
}

class CommentModel {
  String email;
  String name;
  String photo;
  String comment;
  late String id;
  String creationTime;
  CommentModel(
      {required this.email,
      required this.name,
      required this.photo,
      required this.comment,
      required this.creationTime});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      email: json['email'],
      name: json['name'],
      photo: json['photo'],
      comment: json['comment'],
      creationTime: json["creationTime"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo': photo,
      'comment': comment,
      'creationTime': creationTime,
    };
  }
}
