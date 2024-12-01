import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/controllers/page_index_controller.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final PageIndexController() = Get.put(PageIndexController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        // Check if the user is logged in and if their email is verified
        if (snapshot.hasData) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null && user.emailVerified) {
            // User is logged in and email is verified, proceed to home page
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(useMaterial3: false),
              title: "Application",
              initialRoute: Routes.HOME,
              getPages: AppPages.routes,
            );
          } else {
            // User is logged in but email is not verified, go to login page
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(useMaterial3: false),
              title: "Application",
              initialRoute: Routes.LOGIN,
              getPages: AppPages.routes,
            );
          }
        } else {
          // User is not logged in, go to login page
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: false),
            title: "Application",
            initialRoute: Routes.SPLASH,
            getPages: AppPages.routes,
          );
        }
      },
    );
  }
}
