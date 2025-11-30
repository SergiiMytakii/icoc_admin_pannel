import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class GuidePlayer extends StatefulWidget {
  const GuidePlayer({
    super.key,
  });

  @override
  State<GuidePlayer> createState() => _GuidePlayerState();
}

class _GuidePlayerState extends State<GuidePlayer> {
  final YoutubePlayerController controller = YoutubePlayerController(
      params: const YoutubePlayerParams(showFullscreenButton: true));

  bool isRussian = true;
  @override
  void initState() {
    controller
        .loadVideoById(videoId: videoGuideRussianId)
        .then((_) => controller.playVideo());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Row(
            children: [
              const Text('Video Guide'),
              const Spacer(),
              TextButton(
                onPressed: () {
                  if (!isRussian) {
                    setState(() {
                      isRussian = true;
                      controller
                          .loadVideoById(videoId: videoGuideRussianId)
                          .then((_) => controller.playVideo());
                    });
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: isRussian ? Colors.blue : Colors.grey,
                ),
                child: const Text('Ru'),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  if (isRussian) {
                    setState(() {
                      isRussian = false;
                      controller
                          .loadVideoById(videoId: videoGuideEnglishId)
                          .then((_) => controller.playVideo());
                    });
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: !isRussian ? Colors.blue : Colors.grey,
                ),
                child: const Text('En'),
              ),
            ],
          ),
        ],
      ),
      content: AspectRatio(
        aspectRatio: 1,
        child: YoutubePlayer(controller: controller),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
