import 'package:get/get.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/services/post.dart' as post_service;

class PostDiaryController extends GetxController {
  var posts = <dynamic>[].obs;
  var currentPage = 1.obs;
  var loading = false.obs;
  var error = false.obs;

  @override
  void onInit() {
    fetchData().then((data) => posts.assignAll(data));
    super.onInit();
  }

  Future<List<dynamic>> fetchData({bool refetch = false}) async {
    loading.value = true;
    error.value = false;
    try {
      return await post_service.getTimeLinePost(
          currentPage.value, Get.find<AuthController>().user?.username,
          refetch: refetch);
    } catch (e) {
      error.value = true;
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  void loadMore() {
    print('load more');
    if (loading.value || error.value) {
      return;
    }
    currentPage.value++;
    fetchData().then((data) => posts.addAll(data));
    posts.refresh();
  }

  void likePost(String id) async {
    for (int i = 0; i < posts.length; i++) {
      if (posts[i].id == id) {
        posts[i].isLiked = !posts[i].isLiked;
        posts[i].totalLike =
            posts[i].isLiked ? posts[i].totalLike + 1 : posts[i].totalLike - 1;
        update();
      }
    }
    posts.refresh();
    await post_service.likeOrUnlikePost(id);
  }

  Future<void> refetch() async {
    currentPage.value = 1;
    var data = await fetchData(refetch: true);
    posts.assignAll(data);
    posts.refresh();
  }
}
