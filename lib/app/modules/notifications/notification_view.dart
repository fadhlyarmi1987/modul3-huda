import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notification_controller.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Memberikan warna pada AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade100,
              Colors.purple.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.notifications.isEmpty) {
            return const Center(
              child: Text('Tidak ada notifikasi.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 114, 114, 114))),
            );
          }
          return ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    controller.notifications[index],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.blueAccent,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implementasi penghapusan notifikasi jika diperlukan
                      controller.notifications.removeAt(index);
                      Get.snackbar("Notifikasi Dihapus", "Notifikasi berhasil dihapus",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color.fromARGB(213, 255, 99, 71),
                          colorText: Colors.white);
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
