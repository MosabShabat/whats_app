import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/common/provider/message_reply_provider.dart';
import 'package:whats_app/constants/firebase_consts.dart';
import 'package:whats_app/models/chat_contact.dart';
import 'package:whats_app/models/message.dart';
import 'package:whats_app/models/user_model.dart';

import '../../../common/controller/firebase_storge.dart';
import '../../../models/group.dart';

class ChatController extends GetxController {
  Stream<List<Group>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groudId) {
    return firestore
        .collection('groups')
        .doc(groudId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDateToContactsSubcollection(
      UserModel senderUserData,
      UserModel? receiverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId,
      bool isGroupChat) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(receiverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      var receiverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );

      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(
            receiverChatContact.toMap(),
          );

      //===============================
      var senderChatContact = ChatContact(
        name: receiverUserData!.name,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .set(
            senderChatContact.toMap(),
          );
    }
  }

  void _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? receiverUserName,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : receiverUserName ?? '',
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(receiverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendTextMessage(
      {required String text,
      required String receiverUserId,
      required UserModel senderUser,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDateMap =
            await firestore.collection('users').doc(receiverUserId).get();
        recieverUserData = UserModel.fromMap(userDateMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDateToContactsSubcollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        receiverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        // receiverUsername: recieverUserData?.name,
        username: senderUser.name,
        messageReply: messageReply,
        receiverUserName: recieverUserData?.name,
        senderUsername: senderUser.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }

  void sendFileMessage({
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var controller = Get.put(
          FirebaseStorageController(firebaseStorage: FirebaseStorage.instance));
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await controller.storeFileToFirebase(
          'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
          file);
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDateMap =
            await firestore.collection('users').doc(receiverUserId).get();
        recieverUserData = UserModel.fromMap(userDateMap.data()!);
      }

      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎙️ Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'Gif';
          break;

        default:
          contactMsg = 'Gif';
      }
      _saveDateToContactsSubcollection(senderUserData, recieverUserData,
          contactMsg, timeSent, receiverUserId, isGroupChat);

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        receiverUserName: recieverUserData?.name,
        senderUsername: senderUserData.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }

  void setChatMessageSeen(
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      Get.snackbar('Message', e.toString());
    }
  }
}
