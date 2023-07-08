import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/colors.dart';
import 'features/landing/screens/landing_screeen.dart';
import 'mobile_layout_screen.dart';

class SeplashScreen extends StatefulWidget {
  const SeplashScreen({super.key});

  @override
  State<SeplashScreen> createState() => _SeplashScreenState();
}

class _SeplashScreenState extends State<SeplashScreen> {
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data == null) {
                  return const LandingScreen();
                } else {
                  return const MobileLayoutScreen();
                  // Get.offAll(() => const HomeScreen());
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ));
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/whatsapp-icon-0.png'),
            ),
          )
        ],
      ),
    );
  }
}
