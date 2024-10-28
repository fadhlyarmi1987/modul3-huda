import 'package:get/get.dart';
import 'package:liedle/app/modules/setting_profile/controller/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(
      () => SettingController(),
    );
  }
}
