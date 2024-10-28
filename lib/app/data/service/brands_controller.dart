import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:liedle/app/data/model/brands.dart';
import 'package:liedle/app/modules/product_detail/views/product_detail_view.dart';
import 'package:liedle/app/modules/product_detail/views/product_detail_web_view.dart';

class BrandsController extends GetxController {
  static const String _baseUrl =
      'https://my-json-server.typicode.com/Renocalvo/Liedle-Api/';

  RxList<BrandElement> brands = <BrandElement>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    await fetchProduct();
    super.onInit();
  }

  Future<void> fetchProduct() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('${_baseUrl}db'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parsing data dari key "brands" untuk mendapatkan list BrandElement
        final brandData = Brand.fromJson(data);
        brands.value = brandData.brands; // Set list of BrandElement
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
