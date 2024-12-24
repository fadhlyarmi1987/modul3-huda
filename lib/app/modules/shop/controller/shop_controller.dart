import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../splash_screen/SaveProductSplashScreen.dart';

class ShopController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final NumberFormat currencyFormatter = NumberFormat.decimalPattern('id_ID');
  final GetStorage box = GetStorage();
  final RxBool isConnected = true.obs; // Status koneksi internet

  Rx<File?> selectedImage = Rx<File?>(null);
  var savedProducts = <Map<String, dynamic>>[].obs; // Data produk tersimpan
  var filteredProducts =
      <Map<String, dynamic>>[].obs; // Data produk setelah filter
  final List<Map<String, dynamic>> _queue = []; // Antrean produk
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;

  @override
  void onInit() {
    super.onInit();
    loadSavedProducts();
    filteredProducts.value = savedProducts;
    monitorInternetConnection();
  }

  void monitorInternetConnection() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Perbarui status koneksi berdasarkan hasil
      bool connected = result != ConnectivityResult.none;
      if (connected != isConnected.value) {
        isConnected.value = connected;
        Get.snackbar(
          'Status Internet',
          connected ? 'Tersambung ke Internet' : 'Tidak ada koneksi Internet',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: connected ? Colors.green : Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Jika tersambung kembali, proses antrean
        if (connected) {
          _processQueue();
        }
      }
    });
  }

  // Pilih gambar dari galeri
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Pilih gambar dari kamera
  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Simpan produk ke local storage dengan antrean
  void saveProduct(String name, String category, String price) {
    final product = {
      'name': name,
      'category': category,
      'price': price,
      'image': selectedImage.value?.path ?? '',
    };

    if (isConnected.value) {
      // Jika ada koneksi internet, langsung simpan ke local storage
      savedProducts.add(product);
      filteredProducts.value = savedProducts;
      box.write('saved_products', savedProducts);
      selectedImage.value = null;

      Future.delayed(Duration(seconds: 3), () {
        Get.snackbar(
          'Berhasil',
          'Produk berhasil diupload',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3), 
        );
      });
    } else {
      // Jika tidak ada koneksi internet, tambahkan ke antrean
      _queue.add(product);

      Future.delayed(Duration(seconds: 3), () {
        Get.snackbar(
          'Produk Ditambahkan ke Antrean',
          'Produk akan disimpan otomatis saat koneksi internet tersedia',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 3), 
        );
      });
    }
  }

// Proses antrean untuk menyimpan produk ke local storage
  void _processQueue() {
    if (_queue.isNotEmpty) {
      for (var product in _queue) {
        savedProducts.add(product);
      }
      filteredProducts.value = savedProducts;
      box.write('saved_products', savedProducts);
      _queue.clear();
      Get.snackbar(
        'Antrean Diproses',
        'Semua produk yang diupload ketika offline, berhasil ter-upload',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

// Muat produk dari local storage
  void loadSavedProducts() {
    final products = box.read<List>('saved_products') ?? [];
    savedProducts.value =
        products.map((e) => Map<String, dynamic>.from(e)).toList();
    filteredProducts.value = savedProducts;
  }

  // Filter produk berdasarkan pencarian
  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = savedProducts;
    } else {
      filteredProducts.value = savedProducts.where((product) {
        final name = product['name']?.toLowerCase() ?? '';
        final category = product['category']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || category.contains(searchQuery);
      }).toList();
    }
  }

  // Mulai mendengarkan input suara
  Future<void> startListening() async {
    isListening = true;
    update(); // Update UI untuk menunjukkan proses listening
    bool available = await speech.initialize();
    if (available) {
      speech.listen(
        onResult: (result) {
          searchController.text = result.recognizedWords;
          filterProducts(result.recognizedWords);
        },
      );
    } else {
      Get.snackbar('Error', 'Speech-to-text tidak tersedia');
    }
  }

  // Stop mendengarkan suara
  void stopListening() {
    isListening = false;
    speech.stop();
    update();
  }

  void initSpeechToText() async {
    bool available = await speech.initialize();
    if (available) {
      print("Speech recognition initialized successfully");
    } else {
      print("Speech recognition not available");
    }
  }

  void deleteProduct(int index) {
    final productToDelete = savedProducts[index];
    savedProducts.removeWhere((product) => product == productToDelete);
    filteredProducts.value = savedProducts;
    box.write('saved_products', savedProducts);
    update();
    Get.snackbar(
      'Berhasil',
      'Produk Terhapus',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // SHOW MODAL
  void showDeleteConfirmationDialog(
      BuildContext context, Map product, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus Produk"),
          content: Text(
            "Apakah Anda yakin ingin menghapus produk '${product['name']}'?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                deleteProduct(index);
                Navigator.of(context).pop();
              },
              child: Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showAddProductModal(BuildContext context) {
    RxBool isKeyboardVisible = true.obs;

    Get.defaultDialog(
      title: 'Tambah Produk',
      titleStyle: GoogleFonts.alatsi(color: Colors.black),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    String newText =
                        newValue.text.replaceAll(RegExp(r'\D'), '');
                    final formatter = NumberFormat('###', 'id_ID');

                    if (newText.isNotEmpty) {
                      final formatted = formatter.format(int.parse(newText));
                      newText = formatted;
                    }

                    int selectionIndex = newValue.selection.baseOffset;
                    if (newText.length > selectionIndex) {
                      selectionIndex = newText.length;
                    }

                    return newValue.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: selectionIndex),
                    );
                  }),
                ],
              ),
              SizedBox(height: 16),
              Obx(() {
                // Menggunakan MediaQuery untuk mendapatkan tinggi layar dan tinggi keyboard
                double screenHeight = MediaQuery.of(context).size.height;
                double screenWidth = MediaQuery.of(context).size.width;
                double keyboardHeight =
                    MediaQuery.of(context).viewInsets.bottom;

                // Menentukan ukuran gambar berdasarkan kondisi keyboard
                double imageWidth = keyboardHeight > 0
                    ? screenWidth *
                        0.05 // Jika keyboard muncul, gambar menjadi lebih kecil
                    : screenWidth *
                        0.6; // Jika keyboard tidak muncul, gambar tetap besar

                double imageHeight = keyboardHeight > 0
                    ? screenWidth *
                        0.05 // Jika keyboard muncul, gambar menjadi lebih kecil
                    : screenWidth *
                        0.6; // Jika keyboard tidak muncul, gambar tetap besar

                return selectedImage.value != null
                    ? Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            selectedImage.value!,
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Center(
                        child: const Text(
                          'Belum ada gambar dipilih',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      );
              }),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library, color: Colors.blue),
                    onPressed: pickImageFromGallery,
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.blue),
                    onPressed: pickImageFromCamera,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      textConfirm: 'Simpan',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final name = nameController.text;
        final category = categoryController.text;
        final price = priceController.text;

        if (name.isNotEmpty && category.isNotEmpty && price.isNotEmpty) {
          // Menampilkan splash screen dengan delay

          // Simulasi penyimpanan produk
          saveProduct(
              name, category, price); // Pastikan saveProduct bersifat async

          // Bersihkan form
          nameController.clear();
          categoryController.clear();
          priceController.clear();
          selectedImage.value = null;
          Navigator.pop(context);
          showLoadingSplashScreen(context);
        } else {
          Get.snackbar('Error', 'Semua kolom harus diisi');
        }
      },
      textCancel: 'Batal',
      cancelTextColor: Colors.blueAccent,
      barrierDismissible: false,
      onWillPop: () async => true,
    );
  }

  void showLoadingSplashScreen(BuildContext context) {
    Get.to(() => SaveProductSplashScreen(productName: nameController.text),
        opaque: false); 
  }
}
