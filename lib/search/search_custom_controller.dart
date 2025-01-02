import 'package:allworkdone/search/search_provider.dart';
import 'package:get/get.dart';
import 'package:allworkdone/model.dart';

class SearchCustomController extends GetxController {
  final SearchProvider _provider = SearchProvider();
  var isLoading = true.obs;
  var apiResponse = ApiResponseHandler(data: {}, posts: []).obs;

  // Parameters for search
  var keywords = ''.obs;
  var currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // Optionally, you can trigger a default search on initialization
    // fetchSearchResults(keywords: 'dua', page: 1);
  }

  void fetchSearchResults({required String keywords, required int page}) async {
    isLoading(true); // Show loading indicator
    try {
      final response = await _provider.fetchSearchResults(
        keywords: keywords,
        page: page,
      );
      apiResponse.value = response; // Update the observable with fetched data
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch search results: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }
}
