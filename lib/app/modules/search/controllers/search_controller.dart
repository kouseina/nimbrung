import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var searchController = TextEditingController().obs;

  var initialQuery = [].obs;
  var tempQuery = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> searchFriend({required String data, required String email}) async {
    if (data.length == 0) {
      initialQuery.value = [];
      tempQuery.value = [];
    } else {
      String dataCapitalized =
          data.substring(0, 1).toUpperCase() + data.substring(1);

      if (initialQuery.isEmpty && data.length == 1) {
        CollectionReference users = firestore.collection('users');
        final userQuery =
            await users.where('keyName', isEqualTo: dataCapitalized).where('email', isNotEqualTo: email).get();

        if (userQuery.docs.isNotEmpty) {
          for (var i = 0; i < userQuery.docs.length; i++) {
            initialQuery.add(userQuery.docs[i].data() as Map<String, dynamic>);
          }
        } else {
          print('Tidak ada data');
        }
      }

      if (initialQuery.isNotEmpty) {
        tempQuery.value = [];
        for (var element in initialQuery) {
          if (element['name'].toLowerCase().startsWith(
                dataCapitalized.toLowerCase(),
              )) {
            tempQuery.add(element);
          }
        }
      }
    }

    initialQuery.refresh();
    tempQuery.refresh();
  }
}
