import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/app/themes/primary_theme.dart';
import 'package:chat_app/app/utils/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    // return GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Chat App',
    //   initialRoute: Routes.HOME,
    //   getPages: AppPages.routes,
    // );

    return FutureBuilder(
      future: authC.firstInitialized(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Obx(
            () => GetMaterialApp(
              theme: PrimaryTheme().lightTheme,
              darkTheme: PrimaryTheme().darkTheme,
              debugShowCheckedModeBanner: false,
              title: 'Chat App',
              initialRoute: authC.isSkipIntro.isTrue
                  ? authC.isAuth.isTrue
                      ? Routes.HOME
                      : Routes.LOGIN
                  : Routes.INTRODUCTION,
              getPages: AppPages.routes,
            ),
          );
        }

        return const SplashScreen();
      },
    );
  }
}