import 'dart:io';

import 'package:get/get.dart';
import 'package:zola/services/post.dart' as postService;

class CreatePostController extends GetxController {
  String content = "";
  List<File>? images;
  File? video;
  String scope = "public";

  void clearAll() {
    content = "";
    scope = "";
    images = [];
    video = null;
    scope = "public";
    update();
  }

  // add scope to controller
  void addScope(String scope) {
    this.scope = scope;
    print("Add scope: $scope");
    update();
  }

  // add content to controller
  void addContent(String content) {
    this.content = content;
    update();
  }

  // add images to controller
  void addImages(List<File> images) {
    this.images = images;
    update();
  }

  // add video to controller
  void addVideo(File video) {
    this.video = video;
    update();
  }

  Future<void> createPost(context) async {
    try {
      print("video");
      print(video?.path);
      if (images == null && video == null) {
        try {
          await postService.createPost(content, scope: scope);
          return;
        } catch (e) {
          print(e);
          throw Exception(e);
        }
      }

      List<String>? imagesString = images?.map((e) => e.path).toList();
      if (content.trim().isEmpty && imagesString == null && video == null) {
        throw Exception('No data');
      }

      try {
        if (imagesString != null) {
          await postService.createPost(content,
              images: imagesString, scope: scope);
        } else if (video != null) {
          await postService.createPost(content,
              video: video?.path, scope: scope);
        }
      } catch (e) {
        print(e);
        throw Exception('Failed post data');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed post data');
    }
    // post content only
  }
}
