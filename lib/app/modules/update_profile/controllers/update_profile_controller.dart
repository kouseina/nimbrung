import 'dart:io';

import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:chat_app/app/utils/dialog_utils.dart';
import 'package:chat_app/app/utils/image_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  var authC = Get.find<AuthController>();

  late TextEditingController emailController;
  late TextEditingController nameController;
  late ImagePicker imagePicker = ImagePicker();

  XFile? avatarImage;
  bool avatarCompressLoad = false;
  double? avatarProgress;

  void selectAvatar() async {
    try {
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) throw 'error image is null';

      debugPrint('avatar path : ${image.path}');
      debugPrint('avatar name : ${image.name}');

      final imageCompressed = await ImageUtils().compress(
        File(image.path),
        onLoading: (load) {
          avatarCompressLoad = load;
          update();
        },
      );

      if (imageCompressed == null) throw 'error image compressed is null';

      avatarImage = imageCompressed;
    } catch (e) {}
    update();
  }

  void removeAvatar() {
    avatarImage = null;
    update();
  }

  void uploadAvatar() async {
    if (avatarImage == null) return;
    if (avatarProgress != null) return;

    // Points to "images"
    Reference? imagesRef = authC.storage.ref().child("images");

    // Points to "images/space.jpg"
    // Note that you can use variables to create child values
    final fileName = "${authC.usersModel.value.uid}.jpg";
    final spaceRef = imagesRef.child(fileName);

    try {
      final uploadTask = spaceRef.putFile(File(avatarImage?.path ?? ''));
      // Listen for state changes, errors, and completion of the upload.

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress =
                taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
            avatarProgress = progress;
            debugPrint("Upload is ${100 * progress}% complete.");
            update();
            break;
          case TaskState.paused:
            debugPrint("Upload is paused.");
            break;
          case TaskState.canceled:
            debugPrint("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            // ...
            avatarProgress = null;
            authC.updatePhotoProfile(url: await spaceRef.getDownloadURL());
            avatarImage = null;
            DialogUtils.toast('Sukses mengubah foto profil');

            update();
            break;
        }
      });
    } on FirebaseException catch (e) {
      // ...

      debugPrint('Upload Image Error : $e');
    }
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
