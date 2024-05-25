import 'package:flutter/material.dart';

import '../widget/create_room_body.dart';

class CreateRoomView extends StatefulWidget {
  const CreateRoomView({super.key});
  static const id = "CreateRoomView";
  @override
  _CreateRoomView createState() => _CreateRoomView();
}

class _CreateRoomView extends State<CreateRoomView> {
  @override
  Widget build(BuildContext context) {
    return const CreateRoomBody();
  }
}
