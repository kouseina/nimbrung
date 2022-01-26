import 'package:chat_app/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  var authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller.statusController.value.text =
        authC.usersModel.value.status ?? '';

    return Scaffold(
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
          'Ubah Status',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              TextField(
                controller: controller.statusController.value,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Ubah status mu..',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    elevation: 0,
                  ),
                  onPressed: () {
                    authC.updateStatus(
                      status: controller.statusController.value.text,
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
      ),
    );
  }
}
