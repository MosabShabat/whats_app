import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whats_app/features/auth/screens/user_info_screen.dart';
import 'package:whats_app/common/controller/firebase_storge.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/mobile_layout_screen.dart';
import '../../../constants/firebase_consts.dart';
import '../../group/controller/group_controller.dart';
import '../screens/otp_screen.dart';
import '../../../models/group.dart' as group;

// final AuthRepository authRepository = Get.find<AuthRepository>();
// final AuthController authController =
//     Get.put(AuthController(authRepository: authRepository));

class AuthController extends GetxController {
  var isLoading = false.obs;
  var loggedIn = false.obs;
  var storageController = Get.put(
      FirebaseStorageController(firebaseStorage: FirebaseStorage.instance));

  var phoneController = TextEditingController();
  var verificationController = TextEditingController();

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;

    if (userData.data() != null) {
      loggedIn(true);
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<UserCredential?> signInWithPhone({context, phoneNumber}) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Get.to(() => OTPScreen(verificationId: verificationId));
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Get.to(() => const UserInfoScreen());
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl;

      profilePic != null
          ? photoUrl = await storageController.storeFileToFirebase(
              'profilePic/$uid', profilePic)
          : photoUrl =
              'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());

      Get.offAll(() => const MobileLayoutScreen());
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }

  var Groupcontroller = Get.put(GroupController());

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  Stream<group.Group> GroupData(String userId) {
    return firestore
        .collection('groups')
        .doc(userId)
        .snapshots()
        .map((event) => group.Group.fromMap(
              event.data()!,
            ));
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
