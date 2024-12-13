import 'dart:io'; // Untuk memeriksa koneksi internet
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liedle/app/modules/adduser/AddUserView.dart';
import 'package:liedle/app/modules/audio/views/AudioPlayer_Views.dart';
import 'package:liedle/app/modules/category/views/category_view.dart';
import 'package:liedle/app/modules/login/views/login_view.dart';
import 'package:liedle/app/modules/notifications/notification_view.dart';
import 'package:liedle/app/modules/setting_profile/views/setting_view.dart';
import 'package:liedle/app/modules/record/views/SpeechToTextViews.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liedle/app/modules/audio/handler/audio_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String connectionStatus = "Memeriksa koneksi...";
  bool hasInternet = false; // Untuk menyimpan status akses internet
  late final Connectivity _connectivity; // Instance untuk konektivitas

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
  final result = await _connectivity.checkConnectivity();

  if (result != ConnectivityResult.none) {
    hasInternet = await _checkInternetAccess(); // Validasi akses internet
  }

  setState(() {
    if (result == ConnectivityResult.none) {
      connectionStatus = "Tidak ada koneksi internet";
    } else if (!hasInternet) {
      connectionStatus = "Tidak dapat mengakses internet";
    } else {
      connectionStatus = "Terhubung...";
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          connectionStatus = ""; // Hilangkan pesan setelah 3 detik
        });
      });
    }
  });
}


  Future<bool> _checkInternetAccess() async {
    try {
      // Coba akses server Google
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Berhasil mengakses internet
      }
    } catch (_) {
      return false; // Gagal mengakses internet
    }
    return false;
  }

  Future<void> _refreshConnection() async {
    setState(() {
      connectionStatus = "";
    });
    await _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Cek status login

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fashionista'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close)),
              SizedBox(
                width: 200,
              ),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.line_weight_rounded))
            ]),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Shop'),
              onTap: () {
                Get.to(CategoryView());
              },
            ),
            if (user != null) ...[
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Wishlist'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Notification'),
                onTap: () {
                  Get.to(NotificationView());
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Setting'),
                onTap: () {
                  Get.to(SettingView());
                },
              ),
            ],
            ListTile(
              leading: Icon(Icons.info_rounded),
              title: Text('Need Help?'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Sign Up / Login'),
              onTap: () {
                Get.to(LoginView());
              },
            ),
            ListTile(
              leading: Icon(Icons.mic),
              title: Text('Voice Recording'),
              onTap: () {
                Get.to(SpeechToTextPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.record_voice_over),
              title: Text('Audio'),
              onTap: () {
                Get.to(AudioPlayerPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add_alt_1),
              title: Text('Add User'),
              onTap: () {
                Get.to(AddUserView());
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshConnection, // Fungsi untuk refresh status koneksi
        child: Center(
          // Membungkus seluruh layar dengan Center untuk menempatkan logo di tengah
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(), // Agar RefreshIndicator bisa digunakan
            child: Container(
              height: 720,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Menjaga agar kolom tetap di tengah
                children: [
                  // Menampilkan ikon Wi-Fi jika belum terhubung
                  if (!hasInternet)
                    Icon(
                      Icons.wifi,
                      size: 100,
                      color: Colors.blue,
                    ),
                  if (hasInternet)
                    // Menampilkan "Home View" ketika terhubung ke internet
                    Text(
                      "Home View",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  SizedBox(height: 20),
                  Text(
                    connectionStatus,
                    style: TextStyle(
                      color: connectionStatus == "Terhubung"
                          ? Colors.green
                          : Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),
                  // Tombol "Tetap Lanjutkan Secara Offline" jika tidak ada internet
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
