import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whats_app/models/user_model.dart';
import '../../../constants/colors.dart';
import '../../call/controller/callController.dart';
import '../widgets/chat_list.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/bottom_chat_field.dart';
import '../../../models/group.dart' as group;

class MobileChatScreen extends StatefulWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool IsGroupChat;
  final String profilePic;

  const MobileChatScreen(
      {Key? key,
      required this.name,
      required this.uid,
      required this.IsGroupChat,
      required this.profilePic})
      : super(key: key);

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  var controller = Get.put(AuthController());
  var callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    RxBool test = false.obs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: widget.IsGroupChat
            ? StreamBuilder<group.Group>(
                stream: controller.GroupData(
                  widget.uid,
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<group.Group> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var data = snapshot.data!;

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(data.groupPic),
                        ),
                        5.widthBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              )
            : StreamBuilder<UserModel>(
                stream: controller.userData(
                  widget.uid,
                ),
                builder:
                    (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var data = snapshot.data!;

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(data.profilePic),
                        ),
                        5.widthBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data.isOnline ? 'online' : 'offline',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // widget.IsGroupChat
              //     ? controller.GroupData(auth.currentUser!.uid)
              //         .listen((value) {
              //         callController.makeGroupCall(
              //           Call(
              //               callerId: auth.currentUser!.uid,
              //               callerName: widget.name,
              //               callerPic: widget.profilePic,
              //               receiverId: value.groupId,
              //               receiverName: value.name,
              //               receiverPic: value.groupPic,
              //               callId: value.senderId,
              //               hasDialled: true),
              //           Call(
              //               callerId: auth.currentUser!.uid,
              //               callerName: widget.name,
              //               callerPic: widget.profilePic,
              //               receiverId: value.groupId,
              //               receiverName: value.name,
              //               receiverPic: value.groupPic,
              //               callId: value.senderId,
              //               hasDialled: false),
              //         );
              //       })
              //     : controller
              //         .userData(auth.currentUser!.uid)
              //         .listen((value) {
              //         callController.makeCall(
              //           Call(
              //               callerId: auth.currentUser!.uid,
              //               callerName: widget.name,
              //               callerPic: widget.profilePic,
              //               receiverId: value.uid,
              //               receiverName: value.name,
              //               receiverPic: value.profilePic,
              //               callId: value.uid,
              //               hasDialled: true),
              //           Call(
              //               callerId: auth.currentUser!.uid,
              //               callerName: widget.name,
              //               callerPic: widget.profilePic,
              //               receiverId: value.uid,
              //               receiverName: value.name,
              //               receiverPic: value.profilePic,
              //               callId: value.uid,
              //               hasDialled: false),
              //         );
              //       });
            },
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/backgroundImage.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(
          () => Column(
            children: [
              test.value ? const SizedBox() : const SizedBox(),
              Expanded(
                child: ChatList(
                  receiverUserId: widget.uid,
                  IsGroupChat: widget.IsGroupChat,
                ),
              ),
              //controller.GroupData(uid) :
              widget.IsGroupChat
                  ? StreamBuilder<group.Group>(
                      stream: controller.GroupData(widget.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<group.Group> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var data = snapshot.data!;
                          return BottomChatField(
                            IsGroupChat: widget.IsGroupChat,
                            receiverUserId: widget.uid,
                            senderUser: UserModel(
                              name: widget.name,
                              uid: widget.uid,
                              profilePic: data.groupPic,
                              isOnline: false,
                              phoneNumber: '',
                              groupId: [data.groupId],
                            ),
                          );
                        }
                      },
                    )
                  : StreamBuilder<UserModel>(
                      stream: controller.userData(widget.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<UserModel> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var data = snapshot.data!;
                          return BottomChatField(
                            IsGroupChat: widget.IsGroupChat,
                            receiverUserId: widget.uid,
                            senderUser: UserModel(
                              name: widget.name,
                              uid: widget.uid,
                              profilePic: data.profilePic,
                              isOnline: data.isOnline,
                              phoneNumber: data.phoneNumber,
                              groupId: [],
                            ),
                          );
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
