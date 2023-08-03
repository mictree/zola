import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:zola/constants/route.dart';
import 'package:zola/services/socket_service.dart';
import 'package:zola/controller/auth_controller.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  SocketService socketService = Get.put(SocketService(), permanent: true);
  AuthController authController = Get.put(AuthController(), permanent: true);

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    authController.onInit();
    socketService.connectToSocket();
    loadData();
  }

  Future<void> loadData() async {
    // Simulate loading data for 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the home screen
    if (context.mounted && authController.isLoggedIn.value) {
      context.go(RouteConst.diary);
    } else if (context.mounted && !authController.isLoggedIn.value) {
      context.go(RouteConst.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
