import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:whats_app/features/chat/controller/chatController.dart';
import 'package:whats_app/models/chat_contact.dart';
import '../../../constants/colors.dart';
import 'package:intl/intl.dart';
import '../../group/controller/group_controller.dart';
import '../screens/mobile_chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());
    var Groupcontroller = Get.put(GroupController());

    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                  stream: controller.getChatGroups(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var groupData = snapshot.data![index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(
                                    () => MobileChatScreen(
                                          name: groupData.name,
                                          uid: groupData.groupId,
                                          IsGroupChat: true,
                                          profilePic: groupData.groupPic,
                                        ),
                                    transition: Transition.downToUp);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    groupData.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      groupData.lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      groupData.groupPic,
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm().format(
                                      groupData.timeSent,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: dividerColor, indent: 85),
                          ],
                        );
                      },
                    );
                  }),
              StreamBuilder<List<ChatContact>>(
                  stream: controller.getChatContacts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var chatContactData = snapshot.data![index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(
                                    () => MobileChatScreen(
                                          name: chatContactData.name,
                                          uid: chatContactData.contactId,
                                          IsGroupChat: false,
                                          profilePic:
                                              chatContactData.profilePic,
                                        ),
                                    transition: Transition.downToUp);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    chatContactData.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      chatContactData.lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      chatContactData.profilePic,
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm().format(
                                      chatContactData.timeSent,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: dividerColor, indent: 85),
                          ],
                        );
                      },
                    );
                  }),
            ],
          ),
        ));
  }
}
