import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/constants/colors.dart';
import 'package:whats_app/constants/firebase_consts.dart';

import '../../auth/controller/auth_controller.dart';
import '../controller/status_controller.dart';

class ConfirmStatusScreen extends StatefulWidget {
  static const routeName = '/confirm-status-screen';
  final File file;

  const ConfirmStatusScreen({super.key, required this.file});

  @override
  State<ConfirmStatusScreen> createState() => _ConfirmStatusScreenState();
}

class _ConfirmStatusScreenState extends State<ConfirmStatusScreen> {
  var controller = Get.put(StatusController());
  var authController = Get.put(AuthController());
  void addStatus(
    File file,
  ) {
    authController.userData(auth.currentUser!.uid).listen((value) {
      controller.uploadStatus(
        username: value.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: file,
      );
    });
    print('***********************');
    print(authController.userData(auth.currentUser!.uid).listen((value) {
      controller.uploadStatus(
        username: value.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: file,
      );
    }));
    print('***********************');
    print('=================== uploaded here ===================');
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStatus(widget.file),
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(widget.file),
        ),
      ),
    );
  }
}
