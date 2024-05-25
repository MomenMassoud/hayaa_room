

import '../features/post/data/post_modal.dart';

class PostModelM {
  late String id;
  late String ownerName;
  String owner;
  String Owner_photo;
  String Day;
  String Month;
  String Year;
  String Text;
  String Photo;
  List<LikeModal> likes = [];
  List<CommentModel> comments = [];
  bool like = false;
  late int indexLike;
  bool followButton;
  PostModelM(this.owner, this.Owner_photo, this.Text, this.Photo, this.Day,
      this.Month, this.Year, this.followButton);
}
