import 'package:chat_app/app/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

class LoadingUtils {
  static Future<dynamic> fullScreen() async {
    await DialogUtils.showGeneralPopup(
      barrierDismissible: false,
      content: const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
