import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app_getx/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("pegawai").doc(uid).snapshots();
  }

  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Apakah Anda yakin ingin logout?",
      cancel: OutlinedButton(
        onPressed: () => Get.back(), // Menutup dialog jika memilih "Cancel"
        child: const Text("Cancel"),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          await auth.signOut();
          Get.offAllNamed(
              Routes.LOGIN); // Pindah ke halaman login setelah logout
        },
        child: const Text("Yes"),
      ),
    );
  }
}
