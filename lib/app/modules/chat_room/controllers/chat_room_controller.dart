import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  var chatController = TextEditingController().obs;
  var chatFocusNode = FocusNode().obs;

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
}
