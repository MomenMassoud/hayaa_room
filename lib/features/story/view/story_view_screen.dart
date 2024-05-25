import 'package:flutter/material.dart';

import '../widget/story_view_body.dart';

class StoryViewScreen extends StatefulWidget{
  _StoryViewScreen createState()=>_StoryViewScreen();
}

class _StoryViewScreen extends State<StoryViewScreen>{
  @override
  Widget build(BuildContext context) {
    return StoryViewBody();
  }

}