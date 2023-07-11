import 'dart:async';
import 'dart:convert';

import 'package:chat_app/app/data/models/chats_model.dart';
import 'package:chat_app/app/data/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  var chatController = TextEditingController().obs;
  var scrollController = ScrollController().obs;
  var chatFocusNode = FocusNode().obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();

    chatFocusNode.value.addListener(() {
      if (chatFocusNode.value.hasFocus) {
        isShowEmoji.value = false;
      }
    });
  }

  void addEmojiToChat(Emoji emoji) {
    chatController.value.text += emoji.emoji;
  }

  void onBackspacePressed() {
    if (chatController.value.text.isNotEmpty) {
      chatController.value.text = chatController.value.text
          .substring(0, chatController.value.text.length - 2);
    }
  }

  Stream<DocumentSnapshot<Object?>> streamFriend(
      {required String friendEmail}) {
    CollectionReference users = firestore.collection("users");

    return users.doc(friendEmail).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(
      {required String chatId}) {
    CollectionReference chats = firestore.collection("chats");

    return chats
        .doc(chatId)
        .collection("chat")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<void> sendMessage(
      {required String chatId, required ChatModel chatModel}) async {
    if (chatController.value.text.isNotEmpty) {
      chatController.value.text = "";
      String dateNow = DateTime.now().toIso8601String();
      int totalUnread = 0;

      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');

      // final send =
      await chats.doc(chatId).collection('chat').add(chatModel.toJson());

      Timer(
        Duration.zero,
        () => scrollController.value
            .jumpTo(scrollController.value.position.maxScrollExtent),
      );

      await users.doc(chatModel.sender).collection('chats').doc(chatId).update({
        "lastTime": dateNow,
      });

      final checkChatsFriend = await users
          .doc(chatModel.receiver)
          .collection('chats')
          .doc(chatId)
          .get();

      if (checkChatsFriend.exists) {
        final checkUnread = await chats
            .doc(chatId)
            .collection('chat')
            .where("sender", isEqualTo: chatModel.sender)
            .where("isRead", isEqualTo: false)
            .get();

        totalUnread = checkUnread.docs.length;

        final friend =
            users.doc(chatModel.receiver).collection('chats').doc(chatId);

        await friend.update({
          "lastTime": dateNow,
          "total_unread": totalUnread,
        });
      } else {
        await users
            .doc(chatModel.receiver)
            .collection('chats')
            .doc(chatId)
            .set({
          "connection": chatModel.sender,
          "lastTime": dateNow,
          "total_unread": totalUnread,
        });
      }

      /// push notification
      await users.doc(chatModel.receiver).get().then((value) {
        final data = UsersModel.fromJson(value.data() as Map<String, dynamic>);

        debugPrint('friend data : ${data.name} || fcmToken : ${data.fcmToken}');

        pushNotification(
            title: data.name ?? '',
            body: chatModel.message ?? '',
            fcmToken: data.fcmToken ?? '');
      });
    }
  }

  Future<void> pushNotification(
      {required String title,
      required String body,
      required String fcmToken}) async {
    const fcmUrl = "https://fcm.googleapis.com/fcm/send";
    final fcmKey = dotenv.get('FCM_KEY');

    try {
      Map<String, String> headers = {
        "Authorization": "key=$fcmKey",
        "Content-Type": "application/json"
      };

      Map<String, dynamic> req = {
        "notification": {
          "body": body,
          "title": title,
        },
        "to": fcmToken,
      };

      final response = await http.post(Uri.parse(fcmUrl),
          body: json.encode(req), headers: headers);

      debugPrint('response fcm send message : ${response.body}');
    } catch (e) {}
  }
}
