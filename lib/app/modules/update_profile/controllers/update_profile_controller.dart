import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  var authC = Get.find<AuthController>();

  late TextEditingController emailController;
  late TextEditingController nameController;
  late ImagePicker imagePicker = ImagePicker();
  XFile? avatarImage;

  void selectAvatar() async {
    try {
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        print('avatar path : ${image.path}');
        print('avatar name : ${image.name}');
        avatarImage = image;
      }
    } catch (e) {}
    update();
  }

  void removeAvatar() {
    avatarImage = null;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    emailController = TextEditingController(text: authC.usersModel.value.email);
    nameController = TextEditingController(text: authC.usersModel.value.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailController.dispose();
    nameController.dispose();
  }
}
