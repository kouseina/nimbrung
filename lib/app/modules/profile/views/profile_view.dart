import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app/app/themes/primary_theme.dart';
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
      appBar: AppBar(
        elevation: 0,
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
              glowColor: Get.isDarkMode ? Colors.white12 : Colors.black12,
              duration: const Duration(seconds: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white54,
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '${authC.usersModel.value.email}',
              style: TextStyle(
                fontSize: 18,
                color: Get.isDarkMode ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(
                'Ubah Status',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                'Ubah Profil',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => Get.toNamed(Routes.UPDATE_PROFILE),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(
                'Ganti Tema',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.light_mode_rounded),
              onTap: () {
                Get.changeTheme(
                  Get.isDarkMode
                      ? PrimaryTheme().lightTheme
                      : PrimaryTheme().darkTheme,
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: context.mediaQueryPadding.top),
              child: Column(
                children: [
                  const Text('Nimbrung'),
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
