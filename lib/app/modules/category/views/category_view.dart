import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controller/category_controller.dart';

class CategoryView extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('CATEGORY'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.refreshImages();
            },
          ),
          IconButton(
            onPressed: () async {
              await Get.defaultDialog(
                title: 'Pilih Sumber Gambar',
                content: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Kamera'),
                      onTap: () async {
                        Get.back();
                        await controller.pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Galeri'),
                      onTap: () async {
                        Get.back();
                        await controller.pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.65,
          ),
          itemCount: controller.pickedImages.length,
          itemBuilder: (context, index) {
            final imageUrl = controller.pickedImages[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed('/product-detail');
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.0)),
                            child: Image.network(
                              imageUrl, 
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/placeholder.png');
                              },
                            ),
                          ),
                          Positioned(
                            top: 130,
                            right: 8,
                            child: Obx(() => IconButton(
                                  icon: Icon(
                                    controller.isFavoriteList[index]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: controller.isFavoriteList[index]
                                        ? Colors.red
                                        : Colors.black,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    controller.toggleFavorite(index);
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Text(
                        'Gambar ${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
