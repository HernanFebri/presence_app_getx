import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  DetailPresensiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAIL PRESENSI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DateFormat.yMMMMEEEEd()
                        .format(DateTime.parse(data['date'])),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Masuk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                    "Jam     : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"),
                Text(
                    "Posisi : ${data['masuk']?['lat']} , ${data['masuk']!['long']}"),
                Text("Status : ${data['masuk']!['status']}"),
                Text(
                    "Distance : ${data['masuk']!['distance'].toString().split(".").first} meter"),
                Text("Address : ${data['masuk']!['address']}"),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Keluar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(data['keluar']?['date'] == null
                    ? "Jam     :  -"
                    : "Jam     : ${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}"),
                Text(data['keluar']?['lat'] == null &&
                        data['keluar']?['long'] == null
                    ? "Posisi  :  -"
                    : "Posisi : ${data['keluar']?['lat']} , ${data['keluar']!['long']}"),
                Text(data['keluar']?['status'] == null
                    ? "Status  :  -"
                    : "Status : ${data['masuk']!['status']}"),
                Text(data['keluar']?['distance'] == null
                    ? "Distance : -"
                    : "Distance : ${data['keluar']!['distance'].toString().split(".").first} meter"),
                Text(data['keluar']?['address'] == null
                    ? "Address : -"
                    : "Address : ${data['keluar']!['address']}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
