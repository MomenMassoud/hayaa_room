import 'package:flutter/material.dart';

import '../widget/post_view_body.dart';

class PostView extends StatefulWidget{
  _PostView createState()=>_PostView();
}


class _PostView extends State<PostView>{
  @override
  Widget build(BuildContext context) {
    return PostViewBody();
  }

}