import 'package:dio/dio.dart';
import 'package:zola/constants.dart' as constants;
import 'package:zola/models/post_model.dart';

import 'api/api_client.dart';
import 'api/cache_api_client.dart';

const api = constants.api;

Dio dio = Dio();
ApiCacheManager apiCacheManager = ApiCacheManager();
DioClient dioClient = DioClient();

Future<void> getHotPost() async {
  final response = await dioClient.get("$api/post/hot");

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    print("Hot pots load");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<List<PostModel>> getTimeLinePost(int page, String? username,
    {bool refetch = false}) async {
  final response =
      await dioClient.get("$api/post/timeline/$username?offset=$page&pageSize=10");

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    print('get post in service $page');
    List<dynamic> data = response.data['data'];

    List<PostModel> result = data.map((e) {
      return PostModel.fromJson(e);
    }).toList();

    return result;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<List<PostModel>> getRecommendPost() async {
  final response = await dioClient.get("$api/post/recommend?limit=20");

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    List<dynamic> data = response.data['data'];

    List<PostModel> result = data.map((e) {
      return PostModel.fromJson(e);
    }).toList();

    return result;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<List<PostModel>> searchPost(int page, String searchText, String filter,
    {bool refetch = false}) async {
  final response = await dioClient
      .get("$api/post?search=$searchText&filter=$filter&page=$page");

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    print('get post in service $page');
    List<dynamic> data = response.data['data'];

    List<PostModel> result = data.map((e) {
      return PostModel.fromJson(e);
    }).toList();

    return result;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> createPost(String content,
    {List<String>? images, String? video, String? scope}) async {
  try {
    print("Cretae post");
    final formData =
        FormData.fromMap({'content': content, 'scope': scope ?? "public"});

    //post if no attach file
    if (images == null && video == null) {
      final response = await dioClient.post('$api/post/create', {
        'content': content,
        'scope': scope ?? "public",
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('post success');
        return;
      } else {
        throw Exception('Failed post data');
      }
    }
    if (images != null) {
      for (var image in images) {
        formData.files.add(MapEntry(
            'attach_files',
            await MultipartFile.fromFile(image,
                filename: image.split("/").last)));
      }
    }

    if (video != null) {
      formData.files.add(MapEntry(
          'attach_files',
          await MultipartFile.fromFile(video,
              filename: video.split("/").last)));
    }

    final response = await dioClient.post('$api/post/create', formData);

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('post success');
    } else {
      print("error");
      throw Exception('Failed post data');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed post data');
  }
}

Future<PostModel> getPostById(String id) async {
  try {
    final response = await dioClient.get("$api/post/$id");

    if (response.statusCode == 200) {
      // If the server did return a successful response, parse the JSON.
      dynamic data = response.data['data'];
      PostModel result = PostModel.fromJson(data);
      return result;
    } else {
      // If the server did not return a successful response, throw an error.
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}

Future<List<PostModel>> getUserPost(int page, username) async {
  final response =
      await dioClient.get("$api/post/profile/$username?offset=$page");

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    print('get post in service $page');
    List<dynamic> data = response.data['data'];

    List<PostModel> result = data.map((e) {
      return PostModel.fromJson(e);
    }).toList();

    return result;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<List<PostModel>> getUserLikedPost(int page, username) async {
  final response =
      await dioClient.get("$api/post/like?useranme=$username&offset=$page");

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    print('get post in service $page');
    List<dynamic> data = response.data['data'];

    List<PostModel> result = data.map((e) {
      return PostModel.fromJson(e);
    }).toList();

    return result;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> likeOrUnlikePost(String id) async {
  final response =
      await dioClient.put("$api/post/$id/like", queryParameters: {});

  if (response.statusCode! >= 200 && response.statusCode! < 300) {
    // If the server did return a successful response, parse the JSON.
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> deletePost(String id) async {
  try {
    await dioClient.delete("$api/post/$id", null);
  } catch (e) {
    print(e);
    throw Exception('Failed to delete post');
  }
}

Future<void> editPost(String id, String? content,
    {List<String>? images, String? video, String? scope}) async {
  try {
    final formData =
        FormData.fromMap({'content': content, 'scope': scope ?? "public"});
    if (images != null) {
      for (var image in images) {
        formData.files.add(MapEntry(
            'attach_files',
            await MultipartFile.fromFile(image,
                filename: image.split("/").last)));
      }

      if (video != null) {
        formData.files.add(MapEntry(
            'attach_files',
            await MultipartFile.fromFile(video,
                filename: video.split("/").last)));
      }
    }

    await dioClient.patch("$api/post/edit/$id", formData);
  } catch (e) {
    print(e);
    throw Exception('Failed to delete post');
  }
}
