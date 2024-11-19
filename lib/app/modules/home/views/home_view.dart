import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liedle/app/modules/audio/views/AudioPlayer_Views.dart';
import 'package:liedle/app/modules/category/views/category_view.dart';
import 'package:liedle/app/modules/login/views/login_view.dart';
import 'package:liedle/app/modules/notifications/notification_view.dart';
import 'package:liedle/app/modules/setting_profile/views/setting_view.dart';
import '../../record/views/SpeechToTextViews.dart';
import '../controllers/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liedle/app/modules/audio/handler/audio_service_handler.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
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
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Ini Home View',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
