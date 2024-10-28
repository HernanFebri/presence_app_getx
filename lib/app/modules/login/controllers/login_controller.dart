import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app_getx/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        print("Attempting to sign in with email: ${emailC.text}");

        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text.trim(),
          password: passC.text,
        );

        print("User credential: $userCredential");

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified) {
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.defaultDialog(
              title: "Belum Verifikasi",
              middleText:
                  "Kamu belum verifikasi akun ini. Lakukan verifikasi email kamu.",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar("Berhasil",
                          "Kami telah berhasil mengirim email verifikasi ke akun kamu.");
                    } catch (e) {
                      Get.snackbar("Terjadi Kesalahan",
                          "Tidak dapat mengirim email verifikasi. Hubungi admin atau customer service!");
                    }
                  },
                  child: const Text("KIRIM ULANG"),
                )
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        print("Firebase Auth Exception: ${e.code}"); // Tambahkan ini
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password salah");
        } else {
          Get.snackbar(
              "Terjadi Kesalahan", "Kesalahan tidak terduga: ${e.message}");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login: $e");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan password wajib diisi");
    }
  }
}
