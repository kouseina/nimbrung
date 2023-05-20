import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DialogUtils {
  static Future<dynamic> showGeneralPopup({
    double radius = 0,
    Color? color,
    Widget? content,
    bool barrierDismissible = true,
    bool usePadding = false,
  }) async {
    await showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) => WillPopScope(
        onWillPop: () => Future.value(barrierDismissible),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: usePadding ? const EdgeInsets.all(16) : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: content ?? const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

 static void toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
