import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app_getx/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs; // Untuk toggle password visibility
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  // Fungsi Login
  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      if (!GetUtils.isEmail(emailC.text)) {
        Get.snackbar("Terjadi Kesalahan", "Format email tidak valid");
        return;
      }

      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified) {
            isLoading.value = false;
            if (passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            _showEmailVerificationDialog(userCredential);
          }
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password salah");
        } else {
          Get.snackbar("Terjadi Kesalahan",
              "Login gagal. Periksa kembali email dan password anda !");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan password wajib diisi");
    }
  }

  // Fungsi untuk Menampilkan Dialog Verifikasi Email
  void _showEmailVerificationDialog(UserCredential userCredential) {
    Get.defaultDialog(
      title: "Belum Verifikasi",
      middleText:
          "Kamu belum verifikasi akun ini. Lakukan verifikasi email kamu.",
      actions: [
        OutlinedButton(
          onPressed: () {
            isLoading.value = false;
            Get.back();
          },
          child: const Text("CANCEL"),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await userCredential.user!.sendEmailVerification();
              Get.back();
              Get.snackbar("Berhasil",
                  "Kami telah berhasil mengirim email verifikasi ke akun kamu.");
              isLoading.value = false;
            } catch (e) {
              isLoading.value = false;
              Get.snackbar("Terjadi Kesalahan",
                  "Tidak dapat mengirim email verifikasi. Hubungi admin atau customer service!");
            }
          },
          child: const Text("KIRIM ULANG"),
        ),
      ],
    );
  }
}
