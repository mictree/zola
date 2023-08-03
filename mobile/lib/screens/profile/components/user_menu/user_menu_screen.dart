import 'package:flutter/material.dart';
import 'package:zola/screens/profile/components/user_menu/user_menu_body.dart';

class UserMenuScreen extends StatelessWidget {
  const UserMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UserMenuBody(),
    );
  }
}
