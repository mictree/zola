import 'package:get/get.dart';
import 'package:zola/models/user_info.dart';
import 'package:zola/models/user_info_model.dart';
import 'package:zola/utils/secure_storage_helper.dart';
import 'package:zola/services/auth.dart' as auth_service;
import '../services/users.dart' as users_service;

import 'dart:convert';

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;
  final Rx<UserProfileInfoModel?> _user = Rxn<UserProfileInfoModel?>(null);

  UserProfileInfoModel? get user => _user.value;

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoggedIn.value =
          await FlutterSecureStorageHelper.read("isLogin") == "true";

      print('Login in Init: ${isLoggedIn.value}');
      if (isLoggedIn.value) {
        var userJson = await FlutterSecureStorageHelper.read("userInfo");
        Map userMap = jsonDecode(userJson!);
        UserProfileInfoModel userInfo = UserProfileInfoModel(
          id: userMap["id"] as String,
          fullname: userMap["fullname"] as String,
          avatarUrl: userMap["avatarUrl"] as String,
          username: userMap["username"] as String,
          coverUrl: userMap["coverUrl"] as String,
        );

        _user.value = userInfo;
        print(_user.value!.username);
      }
    } catch (e) {
      print(e);
    }
  }

  Future login(String email, String password) async {
    // xử lý đăng nhập ở đây
    var res = await auth_service.login(email, password);
    if (res == "success") {
      isLoggedIn.value = true;
    }
    if (isLoggedIn.value) {
      var userJson = await FlutterSecureStorageHelper.read("userInfo");
      var userMap = jsonDecode(userJson!);

      var userInfo = UserProfileInfoModel(
          id: userMap["id"] as String,
          fullname: userMap["fullname"] as String,
          avatarUrl: userMap["avatarUrl"] as String,
          username: userMap["username"] as String,
          coverUrl: userMap["coverUrl"] as String);
      _user.value = userInfo;
    }
  }

  Future logout() async {
    // xử lý đăng xuất ở đây
    isLoggedIn.value = false;
    await auth_service.logout();
  }

  bool isLogin() {
    return isLoggedIn.value;
  }


  UserProfileInfoModel? getUserInfo() {
    return _user.value;
  }

  Future<void> refetch() async {
    var userMap = await users_service.getUserInfo(_user.value!.username);

    var userInfo = UserProfileInfoModel(
      id: userMap["data"]["_id"],
      fullname: userMap["data"]["fullname"],
      avatarUrl: userMap["data"]["avatarUrl"],
      username: userMap["data"]["username"],
      coverUrl: userMap["data"]["coverUrl"],
      bio: userMap["data"]["contact_info"]["bio"],
    );

    var userInfoSto = UserInfo(
      id: userMap["data"]["_id"],
      fullname: userMap["data"]["fullname"],
      avatarUrl: userMap["data"]["avatarUrl"],
      username: userMap["data"]["username"],
    );
    await FlutterSecureStorageHelper.write(
        "userInfo", jsonEncode(userInfoSto.toJson()));

    _user.value = userInfo;
    _user.refresh();
  }
}
