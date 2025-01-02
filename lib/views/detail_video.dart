import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailVideo extends StatefulWidget {
  final String videoUrl;

  DetailVideo({required this.videoUrl});

  @override
  State<DetailVideo> createState() => _DetailVideoState(videoUrl);
}

class _DetailVideoState extends State<DetailVideo> {
  final String videoUrl;
  _DetailVideoState(this.videoUrl);

  late VideoPlayerController playerController;

  @override
  void initState() {
    super.initState();
    playerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..addListener(() => setState(() {})) // Tambahkan listener
      ..setLooping(true) // Video akan berulang
      ..initialize().then((_) {
        // Memulai pemutaran setelah video selesai diinisialisasi
        playerController.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Resep Video')
          ],
        ),
      ),
      body: Center(
        child: Center(
          child: playerController.value.isInitialized
              ? Container(
                  alignment: Alignment.topCenter,
                  child: buildVideo(),
                )
              : Container(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
          Positioned.fill(child: buildBasicOverlay())
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: playerController.value.aspectRatio,
        child: VideoPlayer(playerController),
      );

  Widget buildBasicOverlay() => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() {
          if (playerController.value.isPlaying) {
            playerController.pause(); // Panggil fungsi dengan tanda kurung ()
          } else {
            playerController.play();
          }
        }),
        child: Stack(
          children: <Widget>[
            buildPlay(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildIndicator(),
            ),
          ],
        ),
      );

  Widget buildIndicator() =>
      VideoProgressIndicator(playerController, allowScrubbing: true);
  Widget buildPlay() => playerController.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 80,
          ),
        );
}
