import 'package:flutter/material.dart';

import '../widget/setting_view_body.dart';


class SettingView extends StatefulWidget{
  static const id = 'SettingView';
  _SettingView createState()=>_SettingView();
}

class _SettingView extends State<SettingView>{
  @override
  Widget build(BuildContext context) {
    return SettingViewBody();
  }

}