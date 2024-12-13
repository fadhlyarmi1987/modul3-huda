import 'package:get/get.dart';
import 'package:liedle/app/modules/audio/bindings/AudioPlayer_Bindings.dart';
import 'package:liedle/app/modules/audio/views/AudioPlayer_Views.dart';
import 'package:liedle/app/modules/category/controller/storageservice.dart';
import 'package:liedle/app/modules/category/views/category_view.dart';
import 'package:liedle/app/modules/home/bindings/home_binding.dart';
import 'package:liedle/app/modules/home/views/home_view.dart';
import 'package:liedle/app/modules/login/bindings/login_binding.dart';
import 'package:liedle/app/modules/login/views/login_view.dart';
import 'package:liedle/app/modules/notifications/notification_binding.dart';
import 'package:liedle/app/modules/notifications/notification_view.dart';
import 'package:liedle/app/modules/product_detail/bindings/product_detail_bindings.dart';
import 'package:liedle/app/modules/product_detail/views/product_detail_view.dart';
import 'package:liedle/app/modules/product_detail/views/product_detail_web_view.dart';
import 'package:liedle/app/modules/record/bindings/SpeechToText_binding.dart';
import 'package:liedle/app/modules/record/views/SpeechToTextViews.dart';
import 'package:liedle/app/modules/register/bindings/register_binding.dart';
import 'package:liedle/app/modules/register/views/register_view.dart';
import 'package:liedle/app/modules/setting_profile/binding/setting_binding.dart';
import 'package:liedle/app/modules/setting_profile/views/setting_view.dart';
import 'package:liedle/middleware/auth_middleware.dart';

import '../../main.dart';
import '../modules/splash_screen/splashscreen.dart'; // Untuk mengakses audioHandler dari main.dart

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
    

  static final routes = [
    GetPage(
      name: _Paths.STORAGESERVICE,
      page: () => ClearStorageView(),
    ),

    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),

    GetPage(
      name: _Paths.CATEGORY,
      page: () => CategoryView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => ProductDetailView(),
      binding: ProductDetailBindings(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.WEBVIEW,
      page: () => ProductDetailWebView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.NOTIFIKASI,
      page: () => NotificationView(),
      binding: NotificationBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.RECORD,
      page: () => SpeechToTextPage(),
      binding: SpeechToTexBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO,
      page: () => AudioPlayerPage(), // Pastikan audioHandler diteruskan
      binding: AudioplayerBindings(),
    ),
  ];
}
