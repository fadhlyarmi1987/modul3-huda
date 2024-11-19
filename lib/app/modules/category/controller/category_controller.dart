import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:liedle/app/data/model/product.dart';
import 'package:liedle/app/data/service/http_controller.dart';

class CategoryController extends GetxController {
  final HttpController httpController = Get.put(HttpController());

  RxList<Product> products = RxList<Product>([]);
  RxList<bool> isFavoriteList = RxList<bool>();
  RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      await httpController.fetchProduct(); // Call HTTP fetch method
      products.value = httpController.products; // Assign products

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

  Future<void> pickImage() async {
    await _requestPermission(); // Request permission for storage

    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final String filePath =
            '/storage/emulated/0/DCIM/Camera/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File newImage = File(filePath);
        await pickedFile.saveTo(newImage.path);

        Get.snackbar(
          'Success',
          'Gambar berhasil disimpan di Gallery',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print('Gambar disimpan di Gallery: $filePath');
      } else {
        Get.snackbar(
          'Error',
          'Tidak ada gambar yang dipilih',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil gambar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error saat mengambil gambar: $e');
    }
  }

  Future<void> pickVideo() async {
    await _requestPermission(); // Request permission for storage

    try {
      final XFile? pickedFile =
          await _picker.pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        

        final String filePath =
            '/storage/emulated/0/DCIM/Camera/${DateTime.now().millisecondsSinceEpoch}.mp4';
        final File newVideo = File(filePath);
        await pickedFile.saveTo(newVideo.path);

        Get.snackbar(
          'Success',
          'Video berhasil disimpan di Gallery',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print('Video disimpan di: $filePath');
      } else {
        Get.snackbar(
          'Error',
          'Tidak ada video yang dipilih',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil video: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error saat mengambil video: $e');
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      Get.snackbar(
        'Permission Denied',
        'Akses penyimpanan diperlukan untuk menyimpan gambar/video',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
  }
}
