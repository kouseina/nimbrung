import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  var emailController = TextEditingController(text: 'loremipsun@gmail.com').obs;
  var nameController = TextEditingController(text: 'Lorem Ipsum').obs;
  var statusController = TextEditingController().obs;
}
