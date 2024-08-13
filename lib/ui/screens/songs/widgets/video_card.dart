import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/get_video_id.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({super.key, required this.youtubeVideo, required this.onTap});

  final YoutubeVideo youtubeVideo;
  final Function onTap;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  String videoId = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    videoId = getVideoId(widget.youtubeVideo.link);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: GestureDetector(
          onTap: () => widget.onTap(videoId),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.youtubeVideo.thumbnail ??
                    YoutubePlayerController.getThumbnail(
                        videoId: videoId, webp: false),

                // errorBuilder: (context, error, stackTrace)r{
                //   return Container(
                //     color: Theme.of(context).scaffoldBackgroundColor,
                //     child: Image.network(placeholderImageUrl),
                //   );
                // },
                height: 200,
                width: 200 * 16 / 9,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  widget.youtubeVideo.lang,
                  style: const TextStyle(
                      color: ScreenColors.songBook,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
