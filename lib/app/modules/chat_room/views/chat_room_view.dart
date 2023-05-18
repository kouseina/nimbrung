import 'dart:async';
import 'dart:io';

import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/data/models/chats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  var authC = Get.find<AuthController>();

  Widget _titleAppbar({String? avatarPath, String? name, String? status}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.black26,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: (avatarPath?.isNotEmpty ?? false)
                ? Image.network(avatarPath ?? '')
                : Image.asset(
                    'assets/logo/noimage.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (name?.isNotEmpty ?? false) ? name ?? '' : 'Loading...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              (status?.isNotEmpty ?? false) ? status ?? '' : 'Loading...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
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
              title: StreamBuilder<DocumentSnapshot<Object?>>(
                stream: controller.streamFriend(
                    friendEmail: Get.arguments["friendEmail"]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    Map data = snapshot.data?.data() as Map;
                    return _titleAppbar(
                      avatarPath: data["photoUrl"],
                      name: data["name"],
                      status: data["status"],
                    );
                  }
                  return _titleAppbar();
                },
              )),
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
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.streamChats(
                    chatId: Get.arguments["chatId"],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final allData = snapshot.data?.docs ?? [];

                      Timer(
                        Duration.zero,
                        () => controller.scrollController.value.jumpTo(
                            controller.scrollController.value.position
                                .maxScrollExtent),
                      );

                      return ListView.builder(
                        controller: controller.scrollController.value,
                        itemCount: allData.length,
                        itemBuilder: (context, index) {
                          var data = allData[index];

                          Widget _item({
                            String? groupTime,
                          }) {
                            return Column(
                              children: [
                                if (groupTime != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      groupTime,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ItemChatWidget(
                                  text: '${data["message"]}',
                                  time: '${data["time"]}',
                                  isSender: '${data["sender"]}' ==
                                      authC.usersModel.value.email,
                                ),
                              ],
                            );
                          }

                          if (index == 0) {
                            return _item(groupTime: data['groupTime']);
                          }

                          if (allData[index]['groupTime'] !=
                              allData[index - 1]['groupTime']) {
                            return _item(groupTime: data['groupTime']);
                          }

                          return _item();
                        },
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
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

                        var date = DateTime.now().toIso8601String();

                        if (controller.chatController.value.text.isNotEmpty) {
                          controller.sendMessage(
                            chatId: argument["chatId"],
                            chatModel: Chat(
                              sender: authC.usersModel.value.email,
                              receiver: argument["friendEmail"],
                              isRead: false,
                              message: controller.chatController.value.text,
                              time: date,
                              groupTime: DateFormat.yMMMMd('en_US').format(
                                DateTime.tryParse(date) ?? DateTime.now(),
                              ),
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
                          bgColor: const Color(0xFFF2F2F2),
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
                  : const SizedBox(),
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
    final DateFormat _formatter = DateFormat('Hm');
    final String dateFormated = _formatter.format(
      DateTime.tryParse(time) ?? DateTime.now(),
    );

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
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: isSender
                    ? const Radius.circular(10)
                    : const Radius.circular(0),
                bottomRight: isSender
                    ? const Radius.circular(0)
                    : const Radius.circular(10),
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
          const SizedBox(
            height: 5,
          ),
          Text(dateFormated),
        ],
      ),
    );
  }
}
