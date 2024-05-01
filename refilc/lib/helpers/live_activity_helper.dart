import 'package:refilc/api/providers/live_card_provider.dart';
import '../api/providers/liveactivity/platform_channel.dart';


class LiveActivityHelper {
  @pragma('vm:entry-point')
  void backgroundJob() async {
    // initialize provider
    if (!LiveCardProvider.hasDayEnd) {
      await PlatformChannel.updateLiveActivity(LiveCardProvider.LAData);
    } else {
      await PlatformChannel.endLiveActivity();
    }
  }
}