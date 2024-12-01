import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../../../controllers/page_index_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Painter
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: GradientBackgroundPainter(),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar-like Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Profile Avatar
                      ClipOval(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller.streamUser(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              String defaultImage =
                                  "https://ui-avatars.com/api/?name=User";

                              if (snapshot.hasData) {
                                Map<String, dynamic> user =
                                    snapshot.data!.data()!;
                                return Image.network(
                                  user["profile"] != null
                                      ? user["profile"]
                                      : defaultImage,
                                  errorBuilder: (context, error, stackTrace) {
                                    return CircleAvatar(
                                      child: Text("${user['name'][0]}"),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                );
                              }
                              return const CircleAvatar();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Name, NIP, Job
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller.streamUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasData) {
                            Map<String, dynamic> user = snapshot.data!.data()!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user["name"] ?? "No Name",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text("${user['nip']} - ${user['job']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    )),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                // Welcome Card
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller.streamUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        Map<String, dynamic> user = snapshot.data!.data()!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Welcome",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              DateFormat('hh:mm a').format(DateTime.now()),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat('EEEE, d MMMM yyyy')
                                  .format(DateTime.now()),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              user["address"] != null
                                  ? "${user["address"]}"
                                  : "Belum ada lokasi.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                // Today's Presence Card
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller.streamTodayPresence(),
                    builder: (context, snapToday) {
                      if (snapToday.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      Map<String, dynamic>? dataToday = snapToday.data?.data();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text("Masuk"),
                              Text(dataToday?["masuk"] == null
                                  ? "-"
                                  : DateFormat.jms().format(DateTime.parse(
                                      dataToday!['masuk']['date']))),
                            ],
                          ),
                          Container(
                            width: 2,
                            height: 40,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              const Text("Keluar"),
                              Text(dataToday?["keluar"] == null
                                  ? "-"
                                  : DateFormat.jms().format(DateTime.parse(
                                      dataToday!['keluar']['date']))),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Last 5 Days Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Colors.grey[300],
                          thickness: 2,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Last 5 days",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),
                              child: const Text("See more"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>>>(
                            stream: controller.streamLastPresence(),
                            builder: (context, snapPresence) {
                              if (snapPresence.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapPresence.data!.docs.isEmpty ||
                                  snapPresence.data == null) {
                                return const Center(
                                  child: Text("Belum ada history presensi."),
                                );
                              }
                              return ListView.builder(
                                itemCount: snapPresence.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      snapPresence.data!.docs[index].data();
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      elevation: 5,
                                      shadowColor: Colors.black.withOpacity(1),
                                      child: InkWell(
                                        onTap: () => Get.toNamed(
                                          Routes.DETAIL_PRESENSI,
                                          arguments: data,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Masuk",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    DateFormat.yMMMEd().format(
                                                      DateTime.parse(
                                                          data['date']),
                                                    ),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  data['masuk']?['date'] == null
                                                      ? "-"
                                                      : DateFormat.jms().format(
                                                          DateTime.parse(
                                                              data['masuk']
                                                                  ?['date']),
                                                        )),
                                              const SizedBox(height: 10),
                                              const Text(
                                                "Keluar",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(data['keluar']?['date'] ==
                                                      null
                                                  ? "-"
                                                  : DateFormat.jms().format(
                                                      DateTime.parse(
                                                          data['keluar']
                                                              ?['date']),
                                                    )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.blue.shade900,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}

// Gradient Background Painter
class GradientBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Latar belakang berwarna putih
    var paint = Paint()
      ..color = Colors.white // Warna latar belakang putih
      ..style = PaintingStyle.fill;

    // Menggambar latar belakang putih penuh
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Path untuk kurva
    var path = Path();
    path.moveTo(0, size.height * 0.3); // Titik awal kurva
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.4, size.width,
        size.height * 0.3); // Kurva
    path.lineTo(size.width, 0); // Garis ke bawah
    path.lineTo(0, 0); // Garis ke atas
    path.close(); // Menutup path

    // Cat untuk kurva berwarna biru
    var curvePaint = Paint()
      ..color = Colors.blue.shade900 // Warna kurva biru
      ..style = PaintingStyle.fill;

    // Menggambar kurva biru
    canvas.drawPath(path, curvePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
