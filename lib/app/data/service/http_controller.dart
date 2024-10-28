import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:liedle/app/data/model/product.dart';
import 'package:http/http.dart' as http;

class HttpController extends GetxController {
  static const String _baseUrl = 'https://api.escuelajs.co/api/v1/products/';

  RxList<Product> products = RxList<Product>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    await fetchProduct();
    super.onInit();
  }

  Future<void> fetchProduct() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Product> productResult =
            jsonData.map((item) => Product.fromJson(item)).toList();

        products.value =
            productResult; // Set the entire list of Product objects
      } else {
        print("Request failed with status ${response.statusCode}");
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading.value = false; // Set loading to false when done
    }
  }
}
