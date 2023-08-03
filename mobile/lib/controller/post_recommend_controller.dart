import 'package:get/get.dart';
import 'package:zola/services/post.dart' as post_service;

class PostRecommendController extends GetxController {
  var posts = <dynamic>[].obs;
  var currentPage = 1.obs;
  var loading = false.obs;
  var error = false.obs;

  @override
  void onInit() {
    fetchData().then((data) => posts.assignAll(data));
    super.onInit();
  }

  Future<List<dynamic>> fetchData() async {
    loading.value = true;
    error.value = false;
    try {
      return await post_service.getRecommendPost();
    } catch (e) {
      error.value = true;
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> refetch() async {
    currentPage.value = 1;
    var data = await fetchData();
    posts.assignAll(data);
    posts.refresh();
  }

  void likePost(String id) async{
    for (var element in posts) {
      if (element.id == id) {
        element.isLiked = !element.isLiked;
        element.totalLike =
            element.isLiked ? element.totalLike + 1 : element.totalLike - 1;
        print(element.totalLike);
      }
    }
    posts.refresh();
    await post_service.likeOrUnlikePost(id);
  }
}
