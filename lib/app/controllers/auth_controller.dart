import 'package:chat_app/app/data/models/users_model.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? _userCredential;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var usersModel = UsersModel().obs;

  Future<void> firstInitialized() async {
    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = value;
      }
    });

    await autoLogin().then((value) {
      if (value) {
        isAuth.value = value;
      }
    });
  }

  Future<bool> skipIntro() async {
    final skipIntroStorage = GetStorage().read('skipIntro');
    if (skipIntroStorage != null && skipIntroStorage == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isSignin = await _googleSignIn.isSignedIn();
      if (isSignin) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);

        final googleAuth = await _currentUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => _userCredential = value);

        CollectionReference users = firestore.collection('users');
        users.doc(_userCredential?.user?.email).update({
          "lastSignInTime":
              _userCredential?.user?.metadata.lastSignInTime?.toIso8601String(),
        });

        final getUserFromFirestore =
            await users.doc(_userCredential?.user?.email).get();

        final currUserData =
            getUserFromFirestore.data() as Map<String, dynamic>;

        usersModel(UsersModel.fromJson(currUserData));

        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      // user sign in with google
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      // checking is sign in
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        final googleAuth = await _currentUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => _userCredential = value);

        // write skipintro to local storage
        GetStorage().write('skipIntro', true);

        CollectionReference users = firestore.collection('users');
        final getUserFromFirestore =
            await users.doc(_userCredential?.user?.email).get();

        if (getUserFromFirestore.data() != null) {
          await users.doc(_userCredential?.user?.email).update({
            "lastSignInTime": _userCredential?.user?.metadata.lastSignInTime
                ?.toIso8601String(),
          });

          final currUserData =
              getUserFromFirestore.data() as Map<String, dynamic>;

          usersModel(UsersModel.fromJson(currUserData));

          isAuth.value = true;
          Get.offAllNamed(Routes.HOME);
        } else {
          await users.doc(_userCredential?.user?.email).set({
            "uid": _userCredential?.user?.uid,
            "name": _userCredential?.user?.displayName,
            "keyName": _userCredential?.user?.displayName
                ?.substring(0, 1)
                .toUpperCase(),
            "email": _userCredential?.user?.email,
            "photoUrl": _userCredential?.user?.photoURL ?? "",
            "status": '',
            "creationTime":
                _userCredential?.user?.metadata.creationTime?.toIso8601String(),
            "lastSignInTime": _userCredential?.user?.metadata.lastSignInTime
                ?.toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
            "chats": [],
          });

          final getUserFromFirestore =
              await users.doc(_userCredential?.user?.email).get();

          final currUserData =
              getUserFromFirestore.data() as Map<String, dynamic>;

          usersModel(UsersModel.fromJson(currUserData));

          isAuth.value = true;
          Get.offAllNamed(Routes.HOME);
        }
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  // PROFILE
  Future<void> updateProfile({
    required String name,
  }) async {
    String keyName = name.substring(0, 1).toUpperCase();

    // Update Firebase
    CollectionReference users = firestore.collection('users');

    await users.doc(_userCredential?.user?.email).update({
      "name": name,
      "keyName": keyName,
      "lastSignInTime":
          _userCredential?.user?.metadata.lastSignInTime?.toIso8601String(),
      "updatedTime": DateTime.now().toIso8601String(),
    }).then((value) {
      // Update UserModel
      usersModel.update((val) {
        val?.name = name;
        val?.keyName = keyName;
        val?.lastSignInTime =
            _userCredential?.user?.metadata.lastSignInTime?.toIso8601String();
        val?.updatedTime = DateTime.now().toIso8601String();
      });

      usersModel.refresh();

      Get.back();
    });
  }

  Future<void> updateStatus({
    required String status,
  }) async {
    // Update Firebase
    CollectionReference users = firestore.collection('users');

    await users.doc(_userCredential?.user?.email).update({
      "status": status,
      "lastSignInTime":
          _userCredential?.user?.metadata.lastSignInTime?.toIso8601String(),
      "updatedTime": DateTime.now().toIso8601String(),
    }).then((value) {
      // Update UserModel
      usersModel.update((val) {
        val?.status = status;
        val?.lastSignInTime =
            _userCredential?.user?.metadata.lastSignInTime?.toIso8601String();
        val?.updatedTime = DateTime.now().toIso8601String();
      });

      usersModel.refresh();

      Get.back();
    });
  }

  // Chat
  Future<void> createNewChat({required String friendEmail}) async {
    String dateNow = DateTime.now().toIso8601String();
    bool flagNewConnection = false;
    var chatId;

    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    final docUser = await users.doc(_currentUser?.email).get();
    final chatDocUser =
        (docUser.data() as Map<String, dynamic>)['chats'] as List;

    if (chatDocUser.isNotEmpty) {
      chatDocUser.forEach((element) {
        if (element['connection'] == friendEmail) {
          chatId = element['chat_id'];
        }
      });
      if (chatId == null) {
        flagNewConnection = true;
      }
    } else {
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      final chatDocs = await chats.where(
        'connections',
        whereIn: [
          [
            _currentUser?.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser?.email,
          ],
        ],
      ).get();

      if (chatDocs.docs.isNotEmpty) {
        final chatsDataId = chatDocs.docs[0].id;
        final chatsData = chatDocs.docs[0].data() as Map<String, dynamic>;

        chatDocUser.add(
          {
            "connection": friendEmail,
            "chat_id": chatsDataId,
            "lastTime": chatsData["lastTime"],
            "total_unread": 0
          },
        );

        await users.doc(_currentUser?.email).update({"chats": chatDocUser});

        usersModel.update((val) {
          val?.chats?.add(
            ChatUser(
              connection: friendEmail,
              chatId: chatsDataId,
              lastTime: chatsData["lastTime"],
              totalUnread: 0,
            ),
          );
        });

        chatId = chatsDataId;

        usersModel.refresh();
      } else {
        final createNewChat = await chats.add({
          "connections": [
            _currentUser?.email,
            friendEmail,
          ],
          "chat": [],
        });

        chatDocUser.add(
          {
            "connection": friendEmail,
            "chat_id": createNewChat.id,
            "lastTime": dateNow,
            "total_unread": 0
          },
        );

        await users.doc(_currentUser?.email).update({"chats": chatDocUser});

        usersModel.update((val) {
          val?.chats?.add(
            ChatUser(
              connection: friendEmail,
              chatId: createNewChat.id,
              lastTime: dateNow,
              totalUnread: 0,
            ),
          );
        });

        chatId = createNewChat.id;

        usersModel.refresh();
      }
    }

    Get.toNamed(Routes.CHAT_ROOM, arguments: chatId);
  }
}
