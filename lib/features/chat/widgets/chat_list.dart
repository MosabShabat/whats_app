import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/constants/firebase_consts.dart';
import 'package:whats_app/features/chat/widgets/sender_message_card.dart';
import 'package:whats_app/models/message.dart';
import '../../../common/provider/message_reply_provider.dart';
import '../controller/chatController.dart';
import 'my_message_card.dart';

class ChatList extends StatefulWidget {
  final String receiverUserId;
  final bool IsGroupChat;

  const ChatList(
      {Key? key, required this.receiverUserId, required this.IsGroupChat})
      : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController messageController = ScrollController();
  //final messageReply = Get.put(MessageReplyController());

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    print('============the Swipe in ChatList=============');
    Get.put(MessageReplyController()).updateMessage(
      message,
      isMe,
      messageEnum,
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());
    return StreamBuilder<List<Message>>(
      stream: widget.IsGroupChat
          ? controller.getGroupChatStream(widget.receiverUserId)
          : controller.getChatStream(widget.receiverUserId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        // print('==========ListView.builder==============');
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(
              messageData.timeSent,
            );

            if (!messageData.isSeen &&
                messageData.recieverid == auth.currentUser!.uid) {
              controller.setChatMessageSeen(
                widget.receiverUserId,
                messageData.messageId,
              );
            }
            if (messageData.senderId == auth.currentUser!.uid) {
              // print('==================MyMessageCard=================');
              // print(
              //   messageData.repliedMessage.toString(),
              // );
              return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  onLeftSwipe: () => onMessageSwipe(
                        messageData.text,
                        true,
                        messageData.type,
                      ),
                  isSeen: messageData.isSeen);
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              username: messageData.repliedTo,
              repliedMessageType: messageData.repliedMessageType,
              onRightSwipe: () => onMessageSwipe(
                messageData.text,
                false,
                messageData.type,
              ),
              repliedText: messageData.repliedMessage,
            );
          },
        );
      },
    );
  }
}
