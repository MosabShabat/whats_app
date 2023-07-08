import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/firebase_consts.dart';
import '../../../models/call.dart';
import '../../../models/group.dart' as model;
import '../screens/call_screen.dart';

class CallController extends GetxController {
  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    Call senderCallData,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());
      // Get.to(
      //     () => MaterialPageRoute(
      //           builder: (context) => CallScreen(
      //             channelId: senderCallData.callId,
      //             call: senderCallData,
      //             isGroupChat: false,
      //           ),
      //         ),
      //     transition: Transition.downToUp);
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }

  void makeGroupCall(
    Call senderCallData,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersUid) {
        await firestore
            .collection('call')
            .doc(id)
            .set(receiverCallData.toMap());
      }
      // Get.to(
      //     () => MaterialPageRoute(
      //           builder: (context) => CallScreen(
      //             channelId: senderCallData.callId,
      //             call: senderCallData,
      //             isGroupChat: true,
      //           ),
      //         ),
      //     transition: Transition.downToUp);
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }

  void endCall(
    String callerId,
    String receiverId,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }

  void endGroupCall(
    String callerId,
    String receiverId,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection('groups').doc(receiverId).get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUid) {
        await firestore.collection('call').doc(id).delete();
      }
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }
}
