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
        backgroundColor: Colors.blueAccent, // Memberikan warna pada AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Pengaturan Username
            Obx(() => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: ListTile(
                    title: const Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(controller.username.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
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
                  ),
                )),
            const Divider(color: Colors.grey),
            // Pengaturan Notifikasi
            Obx(() => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: SwitchListTile(
                    title: const Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: controller.notificationsEnabled.value,
                    onChanged: (value) {
                      controller.toggleNotifications(value);
                    },
                  ),
                )),
            const Divider(color: Colors.grey),
            // Tombol Log Out
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Memberikan warna latar belakang tombol
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  controller.logout();
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
            decoration: const InputDecoration(hintText: 'Masukkan username baru'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Menutup dialog tanpa mengubah
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: textController.text); // Kembali dengan hasil input
              },
              child: const Text('Save', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
}
