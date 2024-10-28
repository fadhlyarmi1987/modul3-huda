import 'package:get/get.dart';

import '../controller/category_controller.dart';

class CategoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );
  }
}
