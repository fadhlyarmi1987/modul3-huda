import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liedle/app/modules/shop/view/shopview.dart';
import 'package:lottie/lottie.dart';
import '../../../map/map_view.dart';
import '../../adduser/AddUserView.dart';
import '../../audio/views/AudioPlayer_Views.dart';
import '../../login/views/login_view.dart';
import '../../notifications/notification_view.dart';
import '../../setting_profile/views/setting_view.dart';
import '../../splash_screen/splashscreentopage.dart';
import '../controllers/home_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController homeController;
  String _selectedLocation = '';
  final TextEditingController _searchController =
      TextEditingController(); // Controller untuk TextField pencarian
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    homeController = Get.put(HomeController());
  }

  void _updateLocation(String location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _searchController.text = result.recognizedWords;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Speech recognition not available")),
      );
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight), // Menentukan tinggi AppBar
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
              'Home',
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blueAccent,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.line_weight_rounded),
                    color: Colors.white,
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => SplashScreenToPage(targetPage: HomeView()));
                },
                tileColor: Colors.blueGrey.shade100,
                textColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text('Shop'),
                onTap: () {
                  String searchQuery = _searchController.text.trim();
                  if (searchQuery.isNotEmpty) {
                    Get.to(() => SplashScreenToPage(
                        targetPage: ShopView(searchQuery: searchQuery)));
                  } else {
                    Get.to(() => SplashScreenToPage(
                        targetPage: ShopView(searchQuery: '')));
                  }
                },
                tileColor: Colors.blueGrey.shade100,
                textColor: Colors.white,
              ),
              if (user != null) ...[
                // ListTile(
                //   leading: const Icon(Icons.favorite),
                //   title: const Text('Wishlist'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Get.to(() => SplashScreenToPage(); // Halaman WishlistView misalnya
                //   },
                //   tileColor: Colors.blueGrey.shade100,
                //   textColor: Colors.white,
                // ),
                ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: const Text('Notification'),
                  onTap: () {
                    Get.to(() =>
                        SplashScreenToPage(targetPage: NotificationView()));
                  },
                  tileColor: Colors.blueGrey.shade100,
                  textColor: Colors.white,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Setting'),
                  tileColor: Colors.blueGrey.shade100,
                  textColor: Colors.white,
                ),
              ],
              ListTile(
                leading: const Icon(Icons.info_rounded),
                title: const Text('Need Help?'),
                onTap: () {
                  Navigator.pop(context);
                },
                tileColor: Colors.blueGrey.shade100,
                textColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Contact Us'),
                onTap: () {
                  Navigator.pop(context);
                },
                tileColor: Colors.blueGrey.shade100,
                textColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Sign Up / Login'),
                onTap: () {
                  Get.to(() => SplashScreenToPage(targetPage: LoginView()));
                },
                tileColor: Colors.blueGrey.shade100,
                textColor: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt_1),
                title: const Text('Add User'),
                onTap: () {
                  Get.to(() => SplashScreenToPage(targetPage: AddUserView()));
                },
                tileColor: Colors.blueGrey.shade100,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.lightBlue.shade50,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // TextField pencarian
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Cari produk atau kategori...',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blueGrey.shade300, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            String searchQuery = _searchController.text.trim();
                            if (searchQuery.isNotEmpty) {
                              Get.to(ShopView(searchQuery: searchQuery));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Masukkan kategori untuk mencari')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: _isListening
                              ? Lottie.asset(
                                  'assets/record.json',
                                  width: 25.0,
                                  height: 25.0,
                                )
                              : Icon(
                                  Icons.mic,
                                  color: Colors.black,
                                ),
                          onPressed: () {
                            if (_isListening) {
                              _stopListening();
                            } else {
                              _startListening();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Pencarian lokasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedLocation.isEmpty
                            ? 'Pencarian lokasi saya'
                            : _selectedLocation,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        Get.to(MapPage(onLocationSelected: _updateLocation));
                      },
                    ),
                  ],
                ),
                //LARGE BANNER
                const SizedBox(height: 2),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                        child: Container(
                          width: 370,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 113, 113, 113),
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: FutureBuilder<String>(
                            future: homeController.getLargeBannerImage(index),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Gagal memuat gambar'));
                              } else if (snapshot.hasData) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: Text('Gambar tidak ditemukan'));
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                //SMALLBANNER
                const SizedBox(height: 16),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 5, 4, 10),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 113, 113, 113),
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: FutureBuilder<String>(
                            future: homeController.getSmallBannerImage(index),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Gagal memuat gambar'));
                              } else if (snapshot.hasData) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: Text('Gambar tidak ditemukan'));
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _categoryButton('Sepatu'),
                    _categoryButton('Baju'),
                    _categoryButton('Celana'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5, // Menambahkan bayangan untuk efek 3D
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Sudut melengkung pada card
                        ),
                        child: FutureBuilder<String>(
                          future: homeController.getPromoBannerImage1(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Gagal memuat gambar'));
                            } else if (snapshot.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            } else {
                              return const Center(
                                  child: Text('Gambar tidak ditemukan'));
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Sudut melengkung pada card
                        ),
                        child: FutureBuilder<String>(
                          future: homeController.getPromoBannerImage2(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Gagal memuat gambar'));
                            } else if (snapshot.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            } else {
                              return const Center(
                                  child: Text('Gambar tidak ditemukan'));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        Get.to(
          () => SplashScreenToPage(
            targetPage: ShopView(
                searchQuery: category), 
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(146, 68, 137, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.white, // Warna teks putih
          fontSize: 16, // Ukuran font
          fontWeight: FontWeight.bold, // Menggunakan font bold
        ),
      ),
    );
  }
}
