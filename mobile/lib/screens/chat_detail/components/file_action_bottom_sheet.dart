import 'package:flutter/material.dart';

class FileActionBottomSheet extends StatelessWidget {
  const FileActionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn ảnh từ thư viện'),
              onTap: () {
                // Xử lý chọn tệp từ thư viện ở đây
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Chụp ảnh'),
              onTap: () {
                // Xử lý chụp ảnh ở đây
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn video từ thư viện'),
              onTap: () {
                // Xử lý chụp ảnh ở đây
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Quay video'),
              onTap: () {
                // Xử lý chụp ảnh ở đây
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Chọn file'),
              onTap: () {
                // Xử lý chụp ảnh ở đây
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
  }
}