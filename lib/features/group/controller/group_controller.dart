import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../common/controller/firebase_storge.dart';
import '../../../constants/firebase_consts.dart';
import '../../../models/group.dart' as model;

class GroupController extends GetxController {
  var groupId = const Uuid().v1();

  void createGroup(
      String name, File profilePic, List<Contact> selectedContact) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContact[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var controller = Get.put(
          FirebaseStorageController(firebaseStorage: FirebaseStorage.instance));
      String profileUrl = await controller.storeFileToFirebase(
        'group/$groupId',
        profilePic,
      );
      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }


    Future<Map<String, dynamic>> getAllGroupData(
      String name, File profilePic, List<Contact> selectedContacts) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      
      var controller = Get.put(
        FirebaseStorageController(firebaseStorage: FirebaseStorage.instance),
      );
      String profileUrl = await controller.storeFileToFirebase(
        'group/$groupId',
        profilePic,
      );

      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      return {'group': group.toMap(), 'profileUrl': profileUrl};
    } catch (e) {
      Get.snackbar('Message', e.toString());
      return {'error': e.toString()};
    }
  }

}
