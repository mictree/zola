import 'package:zola/constants.dart' as constants;
import 'package:zola/models/comment_model.dart';

import 'api/api_client.dart';

const api = constants.api;
DioClient dioClient = DioClient();

Future<List<CommentModel>> getCommentFromPost(String postId) async {
  final response = await dioClient.get("$api/comment/post/$postId");

  if (response.statusCode == 200) {
    // If the server did return a successful response, parse the JSON.
    List<dynamic> data = response.data['data'];

    List<CommentModel> result = data.map((e) {
      return CommentModel.fromJson(e);
    }).toList();

    return result;
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> createComment(String postId, String content) async {
  final response = await dioClient
      .post("$api/comment/create", {"postId": postId, "content": content});

  if (response.statusCode! >= 200 || response.statusCode! < 400) {
    // If the server did return a successful response, parse the JSON.
    print("comment created");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<void> likeComment(String postId) async {
  final response = await dioClient
      .put("$api/comment/$postId/like", queryParameters: {"postId": postId});

  if (response.statusCode! >= 200 || response.statusCode! < 400) {
    // If the server did return a successful response, parse the JSON.
    print("comment like or unliked");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}

//reply comment
Future<void> replyComment(
    String postId, String parentId, String replyTo, String content) async {
  final response = await dioClient.post("$api/comment/create", {
    "postId": postId,
    "parent_id": parentId,
    "reply_to": replyTo,
    "content": content
  });

  if (response.statusCode! >= 200 || response.statusCode! < 400) {
    // If the server did return a successful response, parse the JSON.
    print("Reply comment replied");
  } else {
    // If the server did not return a successful response, throw an error.
    throw Exception('Failed to load data');
  }
}


// get reply comment
Future<List<CommentModel>> getReplies(String commentId) async {
  final response = await dioClient.get("$api/comment/reply/$commentId");

  if (response.statusCode == 200) {
	// If the server did return a successful response, parse the JSON.
	List<dynamic> data = response.data['data'];

	List<CommentModel> result = data.map((e) {
	  return CommentModel.fromJson(e);
	}).toList();

	return result;
  } else {
	// If the server did not return a successful response, throw an error.
	throw Exception('Failed to load data');
  }
}


// delete comment
Future<void> deleteComment(String commentId) async {
  final response = await dioClient.delete("$api/comment/$commentId", null);

  if (response.statusCode! >= 200 || response.statusCode! < 400) {
	// If the server did return a successful response, parse the JSON.
	print("comment deleted");
  } else {
	// If the server did not return a successful response, throw an error.
	throw Exception('Failed to load data');
  }
}