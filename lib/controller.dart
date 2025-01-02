import 'package:allworkdone/provider.dart';
import 'package:get/get.dart';
import 'package:allworkdone/model.dart';

class CategoryController extends GetxController {
  final CategoryProvider _provider = CategoryProvider();
  var isLoading = true.obs;
  var apiResponse = ApiResponseHandler(data: {}, posts: []).obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData(); // Fetch data when the controller is initialized
  }

  void fetchCategoryData() async {
    isLoading(true); // Show loading indicator
    try {
      final response = await _provider.fetchCategoryData();
      apiResponse.value = response; // Update the observable with fetched data
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }
}
