import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  // Method untuk memvalidasi email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void sendEmail() async {
    String email = emailC.text.trim();
    if (email.isNotEmpty) {
      if (_isValidEmail(email)) {
        isLoading.value = true;
        try {
          await auth.sendPasswordResetEmail(email: email);
          Get.snackbar("Berhasil",
              "Kami telah mengirimkan email reset password. Periksa email anda.");
          // Kosongkan isi TextField setelah berhasil
          emailC.clear(); // Menghapus isi TextField
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan",
              "Tidak dapat mengirim email reset password.");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
            "Terjadi Kesalahan", "Silakan masukkan alamat email yang valid.");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Kolom email tidak boleh kosong.");
    }
  }
}
