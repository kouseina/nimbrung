import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  var authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller.emailController.value.text = authC.usersModel.value.email ?? '';
    controller.nameController.value.text = authC.usersModel.value.name ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade800,
          ),
        ),
        title: Text(
          'Ubah Profil',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  AvatarGlow(
                    endRadius: 110,
                    glowColor: Colors.black12,
                    duration: Duration(seconds: 2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: InkWell(
                        onTap: () {
                          print(authC.usersModel.value.photoUrl);
                        },
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.black26,
                          child: (authC.usersModel.value.photoUrl != "")
                              ? Image.network(
                                  "${authC.usersModel.value.photoUrl}",
                                  fit: BoxFit.cover,
                                  height: 1000,
                                )
                              : Image.asset(
                                  'assets/logo/noimage.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller.emailController.value,
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
                  Text(
                    'Nama',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controller.nameController.value,
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
                  padding: EdgeInsets.all(15),
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
