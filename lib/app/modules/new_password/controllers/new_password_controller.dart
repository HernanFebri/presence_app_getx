import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();

  // Observables for loading and password visibility
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        if (newPassC.text.length < 6) {
          Get.snackbar("Terjadi Kesalahan",
              "Password terlalu pendek. Password minimal 6 karakter.");
          return;
        }

        isLoading.value = true; // Start loading
        try {
          String email = auth.currentUser!.email!;

          // Update the password
          await auth.currentUser!.updatePassword(newPassC.text);

          // Logout and login with new password for session refresh
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);

          isLoading.value = false; // Stop loading
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          isLoading.value = false; // Stop loading

          // Error handling
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan",
                "Password terlalu lemah, setidaknya 6 karakter.");
          } else {
            Get.snackbar("Terjadi Kesalahan",
                "Terjadi kesalahan saat membuat password baru. Silakan coba lagi.");
          }
        } catch (e) {
          isLoading.value = false; // Stop loading
          Get.snackbar("Terjadi Kesalahan",
              "Tidak dapat membuat password baru. Hubungi admin atau customer service.");
        }
      } else {
        Get.snackbar("Terjadi Kesalahan",
            "Password baru harus berbeda, jangan gunakan 'password' kembali.");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password baru wajib diisi.");
    }
  }
}
