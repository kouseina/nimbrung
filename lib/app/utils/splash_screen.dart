import 'package:chat_app/app/storages/shared_prefs.dart';
import 'package:chat_app/app/themes/primary_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isDark = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isDark = SharedPrefs().isDark ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: isDark
            ? PrimaryTheme().darkTheme.scaffoldBackgroundColor
            : PrimaryTheme().lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: Container(
            width: Get.width * 0.75,
            height: Get.width * 0.75,
            child: Lottie.asset('assets/lottie/hello.json'),
          ),
        ),
      ),
    );
  }
}
