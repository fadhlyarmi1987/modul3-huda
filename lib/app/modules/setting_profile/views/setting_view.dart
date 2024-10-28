import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liedle/app/modules/home/views/home_view.dart';
import '../controller/setting_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingController controller = Get.put(SettingController());
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contoh pengaturan: nama pengguna
            Obx(() => ListTile(
                  title: const Text('Username'),
                  subtitle: Text(controller.username.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      // Tampilkan dialog untuk mengedit username
                      String? newName = await _showEditDialog(context, controller.username.value);
                      if (newName != null) {
                        // Dapatkan email pengguna yang sedang login
                        String? email = _auth.currentUser?.email;
                        if (email != null) {
                          // Perbarui username di Firestore
                          await _firestore.collection('users').doc(email).update({
                            'name': newName,
                          });
                          // Perbarui username di controller
                          controller.username.value = newName;
                          Get.snackbar("Berhasil", "Anda Telah Berhasil Merubah Nama",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color.fromARGB(213, 76, 175, 79),
                              colorText: Colors.white);
                        }
                      }
                    },
                  ),
                )),
            const Divider(),
            // Contoh pengaturan: notifikasi
            Obx(() => SwitchListTile(
                  title: const Text('Enable Notifications'),
                  value: controller.notificationsEnabled.value,
                  onChanged: (value) {
                    controller.toggleNotifications(value);
                  },
                )),
            const Divider(),
            // Contoh pengaturan: keluar
            ElevatedButton(
              onPressed: () {
                controller.logout();
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String currentUsername) {
    TextEditingController textController = TextEditingController(text: currentUsername);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'masukkan username baru'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Menutup dialog tanpa mengubah
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: textController.text); // Kembali dengan hasil input
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
