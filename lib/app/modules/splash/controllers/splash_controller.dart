import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Pindah ke halaman login setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.LOGIN); // Navigasi ke halaman login
    });
  }
}
