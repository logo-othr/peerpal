import 'package:peerpal/app/domain/support_videos/support_video.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';

class SupportVideos {
  static final Map<VideoIdentifier, SupportVideo> links = {
    VideoIdentifier.discover_tab: SupportVideo(
        identifier: VideoIdentifier.discover_tab,
        link:
            "https://vimp.oth-regensburg.de/m/80c96b8ef0944afcce5d3455a6a047e7ebcca8558e5e0247f317b2f55b83ecedc3568039be0ccd41dda2261d3268fb486192c856e90301663e4d56fb4be2269b"),
    VideoIdentifier.activity_tab: SupportVideo(
        identifier: VideoIdentifier.activity_tab,
        link:
            "https://vimp.oth-regensburg.de/m/6418c3d8a38df808f8e384545adffd2c89a51a107b3458e77f4f3a1f8cd976cdb8aef839aa3a41f0a8ddbbddd063bf0de047f5351c31f139d2522629f5072326"),
    VideoIdentifier.activity_invitation_tab: SupportVideo(
        identifier: VideoIdentifier.activity_invitation_tab,
        link:
            "https://vimp.oth-regensburg.de/m/01bfc9cb37aed8303a20ff52b6bc080d5776cae008b4ff369d44df6ba544a58daeebfc04334de91fc906175753bf496b8e6cb543e6f977bbe44bda51368b746e"),
    VideoIdentifier.chat_tab: SupportVideo(
        identifier: VideoIdentifier.chat_tab,
        link:
            "https://vimp.oth-regensburg.de/m/f87a6808f30e06560dfcf1260f65feb2450da54ad0b189acf7e0df3d959dca88ff68104bef5e4d72136fdf39cce98917c7c6f50a08c332a3191a6379b1988a43"),
    VideoIdentifier.chat_request_tab: SupportVideo(
        identifier: VideoIdentifier.chat_request_tab,
        link:
            "https://vimp.oth-regensburg.de/m/3e3558abf2b2ed07a44bbd038cf2a4a498347461231bf2dbaaee75c4414bfd13aa898b75f0f332e865674c976c48d1d2147804d142033688657f419daa8ebabc"),
    VideoIdentifier.settings_tab: SupportVideo(
        identifier: VideoIdentifier.settings_tab,
        link:
            "https://vimp.oth-regensburg.de/m/47e00d4ed488f2579b376949c5f67d419f419db53b010904fa8395dfac775f9cff9e70facc3e3f18dda44aac7dd342cca7a09b2de55b5c7bc8f4ed88df50a1e5"),
    VideoIdentifier.settings_profile_tab: SupportVideo(
        identifier: VideoIdentifier.settings_profile_tab,
        link:
            "https://vimp.oth-regensburg.de/m/3f7344879c45a6508c2604bac6273f07387a4fa059d76af9cdece0a7b54fde4deab1fc4516bc4dac04b61696a96e4d6a27d4061c7be92ed029c2a714534a9478"),
    VideoIdentifier.friends_tab: SupportVideo(
        identifier: VideoIdentifier.friends_tab,
        link:
            "https://vimp.oth-regensburg.de/m/258c8cdab3fc55da2942fb4094bcc9bcaed099de22f65f711b3530f47ec7f5f5f8d45fb8c645d1035ad4ac1b6268ca8c798381e5496614e3964b3a39a5919c8a"),
  };
}
