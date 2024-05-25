import 'package:flutter/material.dart';

import '../widgets/profile_edit_body.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key, required this.fans, this.isVisitor});
  static const id = 'ProfileEditView';
  final String fans;
  final bool? isVisitor;
  _ProfileEditView createState() => _ProfileEditView();
}

class _ProfileEditView extends State<ProfileEditView> {
  @override
  Widget build(BuildContext context) {
    return ProfileEditBody(
      fans: widget.fans,
      isVisitor: widget.isVisitor,
    );
  }
}
