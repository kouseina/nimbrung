import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeController extends FullLifeCycleController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var authController = Get.find<AuthController>();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    requestPermission();
    setupInteractedMessage();
    tokenSetting();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {
      await firestore
          .collection('users')
          .doc(authController.usersModel.value.email)
          .update({
        'lastOnline': DateTime.now().toIso8601String(),
        'onlineStatus': 0,
      });
    }

    if (state == AppLifecycleState.resumed) {
      await firestore
          .collection('users')
          .doc(authController.usersModel.value.email)
          .update({
        'onlineStatus': 1,
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(
      {required String email}) {
    return firestore
        .collection('users')
        .doc(email)
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendsStream(
      {required String email}) {
    return firestore.collection('users').doc(email).snapshots();
  }

  void navigateToRoomChat(
      {required String chatId,
      required String email,
      required String friendEmail}) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final updateStatus = await chats
        .doc(chatId)
        .collection('chat')
        .where("receiver", isEqualTo: email)
        .where('isRead', isEqualTo: false)
        .get();

    updateStatus.docs.forEach((element) async {
      await chats.doc(chatId).collection("chat").doc(element.id).update({
        "isRead": true,
      });
    });

    await users.doc(email).collection("chats").doc(chatId).update({
      "total_unread": 0,
    });

    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        "chatId": chatId,
        "friendEmail": friendEmail,
      },
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User decline or has not accpet permission');
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // // If `onMessage` is triggered with a notification, construct our own
      // // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'nimbrung',
                'nimbrung',
                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      debugPrint('get message from fcm : ${message.data}');
    }
  }

  void tokenSetting() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
      authController.updateFcmToken(fcmToken: fcmToken);
    }).onError((err) {
      // Error getting token.
    });
  }
}
