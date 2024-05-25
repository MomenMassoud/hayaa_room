class LikeModal {
  final String email;
  final String name;
  final String photo;
  late String id;
  bool like = false;
  LikeModal(this.email, this.name, this.photo);

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'photo': photo,
    };
  }
}
