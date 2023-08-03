import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/models/user_info_model.dart';
import 'package:zola/services/users.dart' as users_service;

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? _avatarImage;
  File? _coverImage;
  TextEditingController? _nameController;
  TextEditingController? _bioController;

  final AuthController authController = Get.find<AuthController>();

  UserProfileInfoModel? userProfileInfoModel;

  @override
  void initState() {
    super.initState();
    users_service.getUserInfo(authController.user!.username).then((value) {
      setState(() {
        userProfileInfoModel = value;
      });
    });
    _nameController =
        TextEditingController(text: authController.user!.fullname);
    _bioController = TextEditingController(text: authController.user!.bio);
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _bioController?.dispose();
    super.dispose();
  }

  Future<void> _pickAvatarImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _avatarImage = File(pickedFile!.path);
    });
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _coverImage = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        actions: [
          TextButton(
              child: const Text(
                "Lưu",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                // check if all of the fields are empty
                if (_nameController?.text == null &&
                    _bioController?.text == null &&
                    _avatarImage == null &&
                    _coverImage == null) {
                  context.pop();
                  return;
                }

                await users_service.updateProfile(
                    _nameController?.text,
                    _bioController?.text,
                    _avatarImage?.path,
                    _coverImage?.path);

                await authController.refetch();
                if (context.mounted) {
                  context.pop();
                }
              }),
        ],
      ),
      body: FutureBuilder(
          future: users_service.getUserInfo(authController.user!.username!),
          builder: (context, snapshot) {
            _bioController?.text =
                snapshot.data?["data"]["contact_info"]["bio"] ?? '';

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickCoverImage,
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            image: _coverImage != null
                                ? DecorationImage(
                                    image: FileImage(_coverImage!),
                                    fit: BoxFit.cover)
                                : authController.user!.coverUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            authController.user!.coverUrl!),
                                        fit: BoxFit.cover)
                                    : null),
                        child: _coverImage == null &&
                                authController.user!.coverUrl == null
                            ? const Center(
                                child: Icon(Icons.camera_alt, size: 50.0))
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      child: GestureDetector(
                        onTap: _pickAvatarImage,
                        child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: _avatarImage != null
                                ? FileImage(_avatarImage!)
                                : authController.user!.avatarUrl != null
                                    ? NetworkImage(
                                            authController.user!.avatarUrl)
                                        as ImageProvider<Object>?
                                    : null,
                            child: _avatarImage == null
                                ? const Icon(Icons.camera_alt, size: 50.0)
                                : null),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: _nameController,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  controller: _bioController,
                  maxLines: 4,
                ),
              ],
            );
          }),
    );
  }
}
