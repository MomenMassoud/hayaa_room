import 'package:flutter/material.dart';

import '../widget/user_level_body.dart';


class UserLevelView extends StatefulWidget{
  const UserLevelView({super.key});
  static const id = 'UserLevelView';
  _UserLevelView createState()=>_UserLevelView();
}

class _UserLevelView extends State<UserLevelView>{
  @override
  Widget build(BuildContext context) {
    return UserLevelBody();
  }

}