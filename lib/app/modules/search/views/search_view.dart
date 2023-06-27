import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_controller.dart' as searchController;

class SearchView extends GetView<searchController.SearchController> {
  var authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBar(
          backgroundColor: Colors.blue.shade400,
          title: const Text('Cari Teman'),
          centerTitle: true,
          elevation: 1,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                onChanged: (value) => controller.searchFriend(
                  data: value,
                  email: '${authC.usersModel.value.email}',
                ),
                controller: controller.searchController.value,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Cari teman baru disini...',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.search,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => controller.tempQuery.isEmpty
            ? Center(
                child: SizedBox(
                  width: Get.width * 0.7,
                  height: Get.height * 0.7,
                  child: Lottie.asset('assets/lottie/empty.json'),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: controller.tempQuery.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.black26,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: controller.tempQuery[index]["PhotoUrl"] != ""
                          ? Image.network(
                              "${controller.tempQuery[index]["photoUrl"]}",
                              fit: BoxFit.cover,
                              height: 100,
                            )
                          : Image.asset(
                              'assets/logo/noimage.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  title: Text('${controller.tempQuery[index]["name"]}'),
                  subtitle: Text('${controller.tempQuery[index]["email"]}'),
                  trailing: const Chip(
                    label: Text('3'),
                  ),
                  onTap: () {
                    authC.createNewChat(
                      friendEmail: '${controller.tempQuery[index]["email"]}',
                    );
                  },
                ),
              ),
      ),
    );
  }
}
