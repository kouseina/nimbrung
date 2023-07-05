import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends FullLifeCycleController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    var authController = Get.find<AuthController>();
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
}
