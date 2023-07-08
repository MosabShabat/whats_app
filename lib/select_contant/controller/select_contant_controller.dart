import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:whats_app/constants/firebase_consts.dart';
import 'package:whats_app/models/user_model.dart';
import '../../features/chat/screens/mobile_chat_screen.dart';

class SelectContactController extends GetxController {
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    //  print(contacts);
    return contacts;
  }

  void selectContact(Contact selectedContact) async {
    try {
      var userCollection = await firestore.collection('users').get();

      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Get.to(
              () => MobileChatScreen(
                    name: userData.name,
                    uid: userData.uid,
                    IsGroupChat: false,
                    profilePic: userData.profilePic,
                  ),
              transition: Transition.downToUp,
              arguments: {
                'name': userData.name,
                'uid': userData.uid,
              });
        }
      }
      if (!isFound) {
        Get.snackbar('Message', 'This number does not exist on this app.');
      }
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }
}
