import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileController extends GetxController {
  @override
  void onInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = 'v${packageInfo.version}';

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  RxString appVersion = ''.obs;
}
