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
            Get.snackbar('Success', 'Storage has been cleared');
          },
          child: Text('Clear Storage'),
        ),
      ),
    );
  }
}

class StorageService {
  final GetStorage _storage = GetStorage();

  /// Clears all data from local storage.
  Future<void> clearStorage() async {
    try {
      await _storage.erase();
      print('Local storage cleared successfully.');
    } catch (e) {
      print('Error clearing local storage: $e');
    }
  }
}
