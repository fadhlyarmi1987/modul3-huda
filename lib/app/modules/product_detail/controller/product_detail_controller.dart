import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductDetailController extends GetxController {
  late final WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();

    // Dapatkan URL dari Get.arguments
    String url = Get.arguments ??
        'https://www.zara.com/id/'; // Default URL jika arguments tidak ada

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }
}
