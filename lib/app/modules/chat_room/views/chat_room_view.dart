import 'dart:io';

import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/data/models/chats_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  var authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey.shade800,
              ),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.black26,
                  child: Image.asset(
                    'assets/logo/noimage.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lorem Ipsum',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Statusnya si lorem ipsum',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isShowEmoji.isTrue) {
            controller.isShowEmoji.value = false;
          } else {
            Navigator.pop(context);
          }

          return Future.value(false);
        },
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ItemChatWidget(
                      text:
                          'Selamat Pagi ksakwkdkskadkwkadk skakdksakdksakdk ksdk kadks jdjskadj jjskadj jksk ajk',
                      time: '19.00',
                    ),
                    ItemChatWidget(
                      text: 'Selamat Pagi juga',
                      time: '19.09',
                      isSender: false,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: controller.chatFocusNode.value,
                        controller: controller.chatController.value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            top: 13,
                            bottom: 13,
                            right: 10,
                            left: 15,
                          ),
                          isDense: true,
                          fillColor: Colors.grey[50],
                          filled: true,
                          hintText: 'Ketik pesan...',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          prefixIcon: InkWell(
                            onTap: () {
                              controller.isShowEmoji.toggle();
                              controller.chatFocusNode.value.unfocus();
                            },
                            child: const Icon(
                              Icons.emoji_emotions_outlined,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        var argument = Get.arguments;

                        if (controller.chatController.value.text.isNotEmpty) {
                          controller.sendMessage(
                            chatId: argument["chatId"],
                            chatModel: Chat(
                              sender: authC.usersModel.value.email,
                              receiver: argument["friendEmail"],
                              isRead: false,
                              message: controller.chatController.value.text,
                              time: DateTime.now().toIso8601String(),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Icon(
                          Icons.send,
                          color: Colors.blue.shade400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              (controller.isShowEmoji.value)
                  ? Container(
                      height: 324,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmojiToChat(emoji);
                        },
                        onBackspacePressed: () {
                          controller.onBackspacePressed();
                        },
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 24 *
                              (Platform.isIOS
                                  ? 1.30
                                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: "No Recents",
                          noRecentsStyle: const TextStyle(
                              fontSize: 20, color: Colors.black26),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemChatWidget extends StatelessWidget {
  String text;
  String time;
  bool isSender;

  ItemChatWidget({
    Key? key,
    required this.text,
    required this.time,
    this.isSender = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: isSender ? 55 : 0,
              right: isSender ? 0 : 55,
            ),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSender ? Colors.blue.shade600 : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: isSender ? Radius.circular(10) : Radius.circular(0),
                bottomRight:
                    isSender ? Radius.circular(0) : Radius.circular(10),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(time),
        ],
      ),
    );
  }
}
