import 'package:chat_app/app/storages/shared_prefs.dart';
import 'package:chat_app/app/themes/primary_theme.dart';
import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/app/utils/splash_screen.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefs().init();

  Get.changeTheme(SharedPrefs().isDark == true
      ? PrimaryTheme().darkTheme
      : PrimaryTheme().lightTheme);

  initLocalNotification();

  runApp(MyApp());
}

void initLocalNotification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {},
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
