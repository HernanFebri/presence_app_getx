import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;

  UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user["nip"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PEGAWAI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
            controller: controller.nipC,
            decoration: const InputDecoration(
              labelText: "NIP",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            readOnly: true,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: controller.nameC,
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Photo Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                builder: (c) {
                  if (c.image != null) {
                    return ClipOval(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          File(c.image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    if (user["profile"] != null) {
                      return Column(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                user["profile"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.deleteProfile(user["uid"]);
                            },
                            child: const Text("delete"),
                          )
                        ],
                      );
                    } else {
                      return const Text("NO IMAGE");
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: const Text("choose"),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.updateProfile(user["uid"]);
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "UPDATE PROFILE"
                  : "LOADING..."),
            ),
          )
        ],
      ),
    );
  }
}
