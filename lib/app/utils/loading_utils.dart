import 'package:chat_app/app/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingUtils {
  static Future<dynamic> fullScreen() async {
    await DialogUtils.showGeneralPopup(
      barrierDismissible: false,
      color: Colors.white,
      radius: 8,
      content: SizedBox(
        height: 200,
        width: 250,
        child: Center(
          child: Lottie.asset('assets/lottie/loading.json'),
        ),
      ),
    );
  }
}
