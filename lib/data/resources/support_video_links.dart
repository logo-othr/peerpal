import 'package:peerpal/app/domain/support_videos/support_video.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';

class SupportVideos {
  static final Map<VideoIdentifier, SupportVideo> links = {
    VideoIdentifier.discover_tab: SupportVideo(
        identifier: VideoIdentifier.discover_tab,
        link: "https://www.youtube.de"),
  };
}
