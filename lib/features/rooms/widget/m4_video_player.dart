import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class M4VideoPlayer extends StatefulWidget {
  const M4VideoPlayer({super.key, required this.videoUrl});
  final String videoUrl;
  @override
  State<M4VideoPlayer> createState() => _M4VideoPlayerState();
}

class _M4VideoPlayerState extends State<M4VideoPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..addListener(() => setState(() {}))
      ..initialize().then((value) => controller.play());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(
                  controller,
                ))
            : Container());
  }
}
