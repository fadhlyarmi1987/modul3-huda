import 'package:get/get.dart';

import 'package:liedle/app/data/model/product.dart';
import 'package:liedle/app/data/service/http_controller.dart';

class CategoryController extends GetxController {
  final HttpController httpController = Get.put(HttpController());

  RxList<Product> products = RxList<Product>([]);
  RxList<bool> isFavoriteList = RxList<bool>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      await httpController.fetchProduct();
      products.value =
          httpController.products; // Assign products from HttpController

      // Initialize isFavoriteList based on the number of products
      isFavoriteList.value = List.generate(products.length, (index) => false);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(int index) {
    if (index < isFavoriteList.length) {
      isFavoriteList[index] = !isFavoriteList[index];
    }
  }
}
