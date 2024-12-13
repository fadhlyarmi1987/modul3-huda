import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liedle/app/modules/category/controller/storageservice.dart';

class ClearStorageView extends StatelessWidget {
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clear Storage'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _storageService.clearStorage();
            Get.snackbar('Berhasil', 'Lokal Storage berhasil dibersihkan');
          },
          child: Text('Clear Storage'),
        ),
      ),
    );
  }
}

class StorageService {
  final GetStorage _storage = GetStorage();


  Future<void> clearStorage() async {
    try {
      await _storage.erase();
      print('foto pada lokal storage berhasil dihapus');
    } catch (e) {
      print('Gagal menghapus local storage: $e');
    }
  }
}
