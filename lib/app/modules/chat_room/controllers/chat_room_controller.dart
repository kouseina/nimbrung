import 'package:chat_app/app/data/models/chats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  var chatController = TextEditingController().obs;
  var chatFocusNode = FocusNode().obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    chatFocusNode.value.addListener(() {
      if (chatFocusNode.value.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
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

  Future<void> sendMessage(
      {required String chatId, required Chat chatModel}) async {
    CollectionReference chats = firestore.collection('chats');

    var send =
        await chats.doc(chatId).collection('chat').add(chatModel.toJson());
    chatController.value.text = "";
  }
}
