
import 'package:get/get.dart';

class MediaController extends GetxController {
  RxBool mute = true.obs;

  toggleMute({required Function() callback}) {
    mute(!mute.value);
    callback();
  }
}
