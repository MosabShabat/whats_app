import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/provider/message_reply_provider.dart';
import 'display_text_image_gif.dart';

class MessageReplyPreview extends StatelessWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply() {
    Get.put(MessageReplyController()).cancelReply();
  }

  @override
  Widget build(BuildContext context) {
    print('=============error here===============');
    var messageReply = Get.put(MessageReplyController());
    return Obx(
      () => messageReply.message.value == null
          ? const SizedBox()
          : Container(
              width: 350,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  // test.value ? const SizedBox() : const SizedBox(),
                  Obx(
                    () {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              messageReply.message.value!.isMe
                                  ? 'Me'
                                  : 'Opposite',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: cancelReply,
                            child: const Icon(
                              Icons.close,
                              size: 18,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  DisplayTextImageGIF(
                      message: messageReply.message.value!.message,
                      type: messageReply.message.value!.messageEnum),
                ],
              ),
            ),
    );
  }
}
