import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

String getVideoId(
  String link,
) {
  //if you use Youtube_player or youtube iFrame player
  if (link.isNotEmpty && link.contains('yout')) {
    try {
      return YoutubePlayerController.convertUrlToId(link) ?? '';
    } on Exception catch (e, stackTrace) {
      logError(e, stackTrace);

      return '';
    }
  } else {
    return link;
    // log.v(videoId);
  }
}
