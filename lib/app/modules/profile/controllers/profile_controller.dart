import 'package:chat_app/app/storages/shared_prefs.dart';
import 'package:chat_app/app/themes/primary_theme.dart';
import 'package:flutter/material.dart';
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

  void changeTheme() {
    final isDark = SharedPrefs().isDark ?? false;
    SharedPrefs().isDark = !isDark;

    Get.changeTheme(
      isDark ? PrimaryTheme().lightTheme : PrimaryTheme().darkTheme,
    );
  }
}
