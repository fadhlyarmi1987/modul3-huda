import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../supabase_constants.dart';

class HomeController extends GetxController {
  late final SupabaseClient supabase;

  // Variabel untuk menyimpan URL gambar
  var largeBannerImage = <String>[].obs;
  var smallBannerImages = <String>[].obs;
  var promoBannerImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    supabase = SupabaseClient(
      SupabaseConstants.supabaseUrl,
      SupabaseConstants.anonKey,
    );
    // Memuat data gambar saat controller diinisialisasi
    loadBannerImages();
  }

  // Memuat gambar banner
  Future<void> loadBannerImages() async {
    try {
      // Gambar besar
      largeBannerImage.value = await Future.wait ([
        getLargeBannerImage(0),
        getLargeBannerImage(1),
        getLargeBannerImage(3),
      ]);

      // Gambar kecil
      smallBannerImages.value = await Future.wait([
        getSmallBannerImage(0),
        getSmallBannerImage(1),
        getSmallBannerImage(2),
        getSmallBannerImage(3),
        getSmallBannerImage(4),
      ]);

      // Gambar promo
      promoBannerImages.value = await Future.wait([
        getPromoBannerImage1(),
        getPromoBannerImage2(),
      ]);
    } catch (e) {
      print("Error loading images: $e");
    }
  }

  // Mendapatkan URL gambar banner besar
  Future<String> getLargeBannerImage(int index) async {
    List<String> bannerImages = [
      'bajularge1.jpg',
      'bajularge2.webp',
      'bajularge3.jpg',
    ];

    final response = await supabase.storage.from('images').createSignedUrl(
          bannerImages[index],
          60 * 60,
        );
    if (response != null) {
      return response;
    } else {
      throw Exception('Gagal mendapatkan URL gambar');
    }
  }

 

  // Mendapatkan URL gambar banner kecil
  Future<String> getSmallBannerImage(int index) async {
    List<String> bannerImages = [
      'small sepatu1.jpg',
      'small celana1.webp',
      'small baju1.jpg',
      'baju4.webp',
      'sepatu2.webp',
    ];

    final response = await supabase.storage.from('huda').createSignedUrl(
          bannerImages[index],
          60 * 60,
        );
    if (response != null) {
      return response;
    } else {
      throw Exception('Gagal mendapatkan URL gambar');
    }
  }

  // Mendapatkan URL gambar banner promo pertama
  Future<String> getPromoBannerImage1() async {
    final response = await supabase.storage.from('huda').createSignedUrl(
          'diskon2.webp',
          60 * 60, // URL berlaku selama 1 jam
        );
    if (response != null) {
      return response;
    } else {
      throw Exception('Gagal mendapatkan URL gambar');
    }
  }

  // Mendapatkan URL gambar banner promo kedua
  Future<String> getPromoBannerImage2() async {
    final response = await supabase.storage.from('huda').createSignedUrl(
          'diskon3.webp',
          60 * 60, // URL berlaku selama 1 jam
        );
    if (response != null) {
      return response;
    } else {
      throw Exception('Gagal mendapatkan URL gambar');
    }
  }
}
