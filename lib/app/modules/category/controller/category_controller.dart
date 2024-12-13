import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:liedle/app/modules/category/controller/storageservice.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Untuk sha256

import '../../../data/model/product.dart';
import '../../../data/service/http_controller.dart';

class CategoryController extends GetxController {
  final HttpController httpController = Get.put(HttpController());
  final GetStorage storageBox = GetStorage();

  RxList<Product> products = RxList<Product>([]);
  RxList<bool> isFavoriteList = RxList<bool>();
  RxList<String> pendingUploads = RxList<String>();
  RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  RxList<String> pickedImages = RxList<String>();

  late final SupabaseClient supabase;

  @override
  void onInit() {
    super.onInit();
    initializeSupabase();
    fetchProducts();
    fetchImagesFromSupabase();
    _checkPendingUploads(); // Mengecek dan mengupload gambar yang tertunda
  }

  void initializeSupabase() {
    final String supabaseUrl = 'https://gvbhlgqrlscsmxptpszk.supabase.co';
    final String supabaseKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd2YmhsZ3FybHNjc214cHRwc3prIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM5Nzk4MjQsImV4cCI6MjA0OTU1NTgyNH0.uNIEkQIlFymLHngrvX3yxvuLIGoG-18CxOQVf4UZD6c';
    supabase = SupabaseClient(supabaseUrl, supabaseKey);
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      await httpController.fetchProduct();
      products.value = httpController.products;
      isFavoriteList.value = List.generate(products.length, (_) => false);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data produk: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(int index) {
    if (index < isFavoriteList.length) {
      isFavoriteList[index] = !isFavoriteList[index];
    }
  }

  Future<void> saveImageToDevice(File file, String fileName) async {
    try {
      // Dapatkan waktu saat ini
      final DateTime now = DateTime.now();
      final String formattedDate =
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
      final String formattedTime =
          "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
      final String fileName = "${formattedDate}_$formattedTime.jpg";

      final String localPath = '/storage/emulated/0/DCIM/Camera/$fileName';

      await file.copy(localPath);

      print('File berhasil disimpan di perangkat: $localPath');
    } catch (e) {
      print('Error saat menyimpan file ke perangkat: $e');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    await _requestPermission();

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        pickedImages.add(pickedFile.path);
        update();

        final connectivityResult = await Connectivity().checkConnectivity();
        print('Connectivity result: $connectivityResult');

        if (connectivityResult != ConnectivityResult.none) {
          print('Ada koneksi internet');
          await uploadImageToSupabase(pickedFile);
        } else {
          print('Tidak ada koneksi internet');
          await saveImageToDevice(File(pickedFile.path), pickedFile.name);
        }
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
    }
  }

  Future<void> uploadImageToSupabase(XFile imageFile) async {
    try {
      File file = File(imageFile.path);
      final storage = supabase.storage.from('images');

      // Generate hash untuk gambar
      final String imageHash = await generateImageHash(file);

      // Cek jika gambar dengan hash ini sudah ada
      final List<String> uploadedHashes =
          storageBox.read<List<dynamic>>('uploadedHashes')?.cast<String>() ?? [];

      if (uploadedHashes.contains(imageHash)) {
        print('Gambar sudah terupload sebelumnya, melewati upload.');
        return; // Gambar sudah terupload, tidak perlu upload lagi
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final response = await storage.upload(fileName, file);

      if (response.isEmpty != null) {
        throw Exception('Failed to upload image to Supabase');
      }

      String imageUrl = supabase.storage.from('images').getPublicUrl(fileName);
      print('Image URL: $imageUrl');

      pickedImages.add(imageUrl);
      saveImageToLocalStorage(imageUrl);

      // Simpan hash gambar yang telah terupload
      uploadedHashes.add(imageHash);
      storageBox.write('uploadedHashes', uploadedHashes);

      await saveImageToDevice(file, fileName);

      update();
    } catch (e) {
      saveImageToLocalStorage(imageFile.path);
      Get.snackbar(
        'Berhasil',
        'Gambar telah terupload ke database',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void saveImageToLocalStorage(String imageUrl) {
    final savedImages =
        storageBox.read<List<dynamic>>('uploadedImages')?.cast<String>() ?? [];
    savedImages.add(imageUrl);
    storageBox.write('uploadedImages', savedImages);
    print('Tersimpan di Local Storage: ${storageBox.read('uploadedImages')}');
  }

  Future<String> generateImageHash(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<void> _checkPendingUploads() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _uploadPendingImages();
    }
  }

  Future<void> _uploadPendingImages() async {
    try {
      final savedImages =
          storageBox.read<List<dynamic>>('uploadedImages')?.cast<String>() ??
              [];

      if (savedImages.isNotEmpty) {
        final tempSavedImages = List<String>.from(savedImages);

        for (final imageUrl in tempSavedImages) {
          final file = File(imageUrl);

          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult != ConnectivityResult.none) {
            await uploadImageToSupabase(XFile(imageUrl));

            savedImages.remove(imageUrl);
          }
        }

        storageBox.write('uploadedImages', savedImages);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengupload gambar yang tertunda: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    }
  }

  Future<void> refreshImages() async {
  try {
    // Cek koneksi internet sebelum memuat ulang gambar
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        'No Internet',
        'Tidak ada koneksi internet. Coba lagi nanti.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Jika tidak ada koneksi, batalkan refresh
    }

    // Jika ada koneksi, lakukan refresh gambar
    pickedImages.clear();
    await fetchImagesFromSupabase(); // Memuat ulang gambar dari Supabase
    await _uploadPendingImages(); // Mengupload gambar yang tertunda

    // Panggil fungsi clearStorage dari StorageService
    final StorageService _storageService = StorageService();
    await _storageService.clearStorage();
    print('Storage has been cleared after refreshing images.');

    update(); // Perbarui UI
  } catch (e) {
    Get.snackbar(
      'Error',
      'Gagal memuat ulang gambar: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}



  Future<void> fetchImagesFromSupabase() async {
    try {
      final storage = supabase.storage.from('images');
      final files = await storage.list();

      if (files.isNotEmpty) {
        pickedImages.clear();
        for (final file in files) {
          final imageUrl = storage.getPublicUrl(file.name);
          pickedImages.add(imageUrl);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat menampilkan gambar karena anda sedang offline',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(113, 79, 73, 72),
        colorText: Colors.white,
      );
    }
  }
}
