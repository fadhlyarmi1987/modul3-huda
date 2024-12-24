import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../controller/shop_controller.dart';
import 'package:intl/intl.dart';

class ShopView extends StatefulWidget {
  final String searchQuery;

  const ShopView({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  final ShopController controller = Get.put(ShopController());
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  // Format harga menjadi Rupiah
  String formatRupiah(double price) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(price);
  }

  @override
  void initState() {
    super.initState();
    controller.initSpeechToText();
    controller.searchController.text = widget.searchQuery;
    controller.filterProducts(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                const Color.fromARGB(255, 213, 79, 237)
              ], // Ubah warna sesuai keinginan
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text(
              'Shop View',
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              TextField(
                controller: controller.searchController,
                onChanged: (value) => controller.filterProducts(value),
                decoration: InputDecoration(
                  hintText: 'Cari nama atau kategori produk...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 1.5,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ikon Search
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          controller
                              .filterProducts(controller.searchController.text);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isListening = !_isListening;
                            });

                            if (_isListening) {
                              // Start listening
                              controller.startListening();
                            } else {
                              // Stop listening
                              controller.stopListening();
                            }
                          },
                          child: _isListening
                              ? Lottie.asset(
                                  'assets/record.json', // Path ke file Lottie
                                  width: 25.0,
                                  height: 25.0,
                                )
                              : Icon(
                                  Icons.mic,
                                  color: Colors.black,
                                  size: 25.0,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),
              // Produk hasil pencarian
              Obx(() {
                if (controller.filteredProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada produk ditemukan',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      return GestureDetector(
                        onLongPress: () {
                          controller.showDeleteConfirmationDialog(
                              context, product, index);
                        },
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Gambar produk
                              product['image'] != ''
                                  ? Image.file(
                                      File(product[
                                          'image']!),
                                      width: double.infinity,
                                      height: 170.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/placeholder.png', 
                                      width: double.infinity,
                                      height: 170.0,
                                      fit: BoxFit.cover,
                                    ),

                              // Nama produk
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['name']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Kategori
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Kategori: ${product['category']}',
                                  style: GoogleFonts.lato(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Harga produk
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Harga: ${formatRupiah(double.tryParse(product['price']!) ?? 0)}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(194, 10, 81, 245),
              const Color.fromARGB(217, 243, 173, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: FloatingActionButton(
          onPressed: () => controller.showAddProductModal(context),
          child: const Icon(Icons.add),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
