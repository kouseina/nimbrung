import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            onPressed: () => authC.logout(),
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.red.shade400,
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            AvatarGlow(
              endRadius: 110,
              glowColor: Colors.black12,
              duration: Duration(seconds: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
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
            const SizedBox(
              height: 15,
            ),
            Text(
              '${authC.usersModel.value.name}',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '${authC.usersModel.value.email}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black45,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: const Text(
                'Ubah Status',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text(
                'Ubah Profil',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () => Get.toNamed(Routes.UPDATE_PROFILE),
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: const Text(
                'Ganti Tema',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.light_mode_rounded),
              onTap: () {},
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: context.mediaQueryPadding.top),
              child: Column(
                children: [
                  Text('Nimbrung'),
                  Text(controller.appVersion.value),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
