import 'dart:convert'; // Untuk encoding ke JSON
import 'dart:io'; // Untuk bekerja dengan file
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart'; // Untuk akses direktori penyimpanan lokal

class AddUserView extends StatefulWidget {
  const AddUserView({super.key});

  @override
  _AddUserViewState createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // Fungsi untuk mengecek koneksi internet
  Future<bool> _isConnectedToInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none; // Jika tidak ada koneksi, return false
  }

  // Fungsi untuk menyimpan data ke file lokal
  Future<void> _saveUserLocally(String name, String email, String password) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('/storage/emulated/0/Pictures');
    List<Map<String, String>> usersList = [];

    // Cek apakah file sudah ada dan baca data sebelumnya
    if (file.existsSync()) {
      String fileContents = await file.readAsString();
      usersList = List<Map<String, String>>.from(json.decode(fileContents));
    }

    // Menambahkan data user ke list
    usersList.add({
      'name': name,
      'email': email,
      'password': password,
    });

    // Simpan kembali ke file
    await file.writeAsString(json.encode(usersList));
  }

  // Fungsi untuk upload data dari file lokal ke Firebase
  Future<void> _uploadUserDataFromFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/users_to_upload.json');

    if (file.existsSync()) {
      String fileContents = await file.readAsString();
      List<Map<String, String>> usersList = List<Map<String, String>>.from(json.decode(fileContents));

      for (var user in usersList) {
        try {
          await _auth.createUserWithEmailAndPassword(
            email: user['email']!,
            password: user['password']!,
          );
          print("User ${user['name']} berhasil ditambahkan");
        } catch (e) {
          print("Gagal menambahkan ${user['name']}: $e");
        }
      }

      // Setelah upload selesai, hapus file
      await file.delete();
    }
  }

  Future<void> _addUser() async {
    bool isConnected = await _isConnectedToInternet();

    if (!isConnected) {
      // Simpan data lokal jika tidak ada koneksi internet
      _saveUserLocally(_nameController.text, _emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tidak ada koneksi internet. Data disimpan secara lokal.")),
      );
      return;
    }

    try {
      // Jika terhubung ke internet, lanjutkan proses pembuatan user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Jika berhasil, upload data dari file lokal jika ada
      await _uploadUserDataFromFile();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User berhasil ditambahkan")),
      );

      // Reset input fields setelah berhasil
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah User"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addUser,
                child: Text("Tambah User"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
