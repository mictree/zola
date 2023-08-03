import 'package:get/get.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/services/post.dart' as postService;

class PostUserLikedController extends GetxController {
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
      return await postService.getUserLikedPost(
          currentPage.value, Get.find<AuthController>().user?.username);
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

  void likePost(String id) {
    for (var element in posts) {
      if (element.id == id) {
        element.isLiked = !element.isLiked;
        element.totalLike =
            element.isLiked ? element.totalLike + 1 : element.totalLike - 1;
        print(element.totalLike);
      }
    }
    posts.refresh();
  }
}
