import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/features/auth/controller/auth_controller.dart';
import 'package:whats_app/features/group/screens/create_group_screen.dart';
import 'package:whats_app/features/status/screens/status_contacts.screen.dart';
import 'constants/colors.dart';
import 'features/status/screens/confirm_status_screen.dart';
import 'select_contant/screens/select_contacts_screen.dart';
import 'features/chat/widgets/contacts_list.dart';

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  var controller = Get.put(AuthController());
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        controller.setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        controller.setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Create Group'),
                        onTap: () {
                          Future(
                            () => Get.to(() => const CreateGroupScreen(),
                                transition: Transition.upToDown),
                          );
                        },
                      )
                    ]),
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(controller: tabController, children: const [
          ContactsList(),
          StatusContactsScreen(),
          Text('Calls'),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabController.index == 0) {
              Get.to(() => const SelectContactsScreen(),
                  transition: Transition.downToUp);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Get.to(
                    () => ConfirmStatusScreen(
                          file: pickedImage,
                        ),
                    arguments: pickedImage,
                    transition: Transition.downToUp);
              }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
