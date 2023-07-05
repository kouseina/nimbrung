import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/data/models/users_model.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  Widget chat(
      {required UsersModel friendData,
      required int totalUnread,
      required String chatId}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.black26,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: '${friendData.photoUrl}' != ""
              ? Image.network(
                  "${friendData.photoUrl}",
                  fit: BoxFit.cover,
                  height: 100,
                )
              : Image.asset(
                  'assets/logo/noimage.png',
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text('${friendData.name}'),
      subtitle: Text('${friendData.email}'),
      trailing: totalUnread > 0
          ? Chip(
              label: Text('$totalUnread'),
            )
          : null,
      onTap: () => controller.navigateToRoomChat(
        chatId: chatId,
        email: authC.usersModel.value.email ?? "",
        friendEmail: friendData.email ?? "",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nimbrung',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed(Routes.PROFILE),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatsStream(
                  email: authC.usersModel.value.email ?? ''),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  List allChats = snapshot1.data?.docs ?? [];

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: allChats.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller.friendsStream(
                          email: allChats[index]["connection"] ?? '',
                        ),
                        builder: (context, snapshot2) {
                          if (snapshot2.data?.data() != null) {
                            UsersModel friendData = UsersModel.fromJson(
                                snapshot2.data?.data() as Map<String, dynamic>);

                            if (snapshot2.connectionState ==
                                ConnectionState.active) {
                              return chat(
                                friendData: friendData,
                                totalUnread:
                                    allChats[index]["total_unread"] ?? {},
                                chatId: allChats[index].id,
                              );
                            }
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        backgroundColor: Colors.blue.shade400,
        child: const Icon(Icons.message_rounded),
      ),
    );
  }
}
