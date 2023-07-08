import 'package:get/get.dart';
import '../enums/message_enum.dart';

class MessageReplyController extends GetxController {
  Rx<MessageReply?> message = Rx<MessageReply?>(null);

  void updateMessage(String message, bool isMe, MessageEnum messageEnum) {
    this.message.value = MessageReply(message, isMe, messageEnum);
  }

  void cancelReply() {
    message.value = null;
    print('cancel');
  }
}

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(this.message, this.isMe, this.messageEnum);
}
