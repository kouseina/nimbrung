import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  Widget _avatar(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      init: UpdateProfileController(),
      initState: (_) {},
      builder: (controller) {
        return Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  controller.selectAvatar();
                },
                child: Stack(
                  children: [
                    AvatarGlow(
                      endRadius: 110,
                      glowColor:
                          Get.isDarkMode ? Colors.white12 : Colors.black12,
                      duration: const Duration(seconds: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white54,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              if (controller.avatarImage != null)
                                Image.file(
                                  File(controller.avatarImage!.path),
                                )
                              else if (authC.usersModel.value.photoUrl != "")
                                Obx(
                                  () => Image.network(
                                    "${authC.usersModel.value.photoUrl}",
                                    fit: BoxFit.cover,
                                    height: 1000,
                                  ),
                                )
                              else
                                Image.asset(
                                  'assets/logo/noimage.png',
                                  fit: BoxFit.cover,
                                ),
                              if (controller.avatarCompressLoad)
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              if (controller.avatarProgress != null)
                                Center(
                                  child: CircularProgressIndicator(
                                    value: controller.avatarProgress,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 35,
                      right: 35,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.avatarImage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.removeAvatar();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.red.shade400,
                        ),
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.uploadAvatar();
                        },
                        child: Icon(
                          Icons.check,
                          color: Colors.green.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text('Ubah Profil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _avatar(context),
                  const SizedBox(
                    height: 25,
                  ),
                  Text('Email', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller.emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Masukkan email anda',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text('Nama', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Masukkan nama anda',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  elevation: 0,
                ),
                onPressed: () {
                  authC.updateProfile(
                    name: controller.nameController.value.text,
                  );
                },
                child: const Text(
                  'Ubah',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
