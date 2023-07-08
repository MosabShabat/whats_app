import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_app/common/enums/message_enum.dart';
import 'package:whats_app/common/utils/utils.dart';
import 'package:whats_app/models/user_model.dart';

import '../../../common/provider/message_reply_provider.dart';
import '../../../constants/colors.dart';
import '../controller/chatController.dart';
import 'message_replay_preview.dart';

class BottomChatField extends StatefulWidget {
  final String receiverUserId;
  final bool IsGroupChat;
  final UserModel senderUser;

  const BottomChatField({
    super.key,
    required this.receiverUserId,
    required this.senderUser,
    required this.IsGroupChat,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  var chatController = Get.put(ChatController());
  final _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  FlutterSoundRecorder? _soundRecorder;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission not allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showKeyboard();
    }
  }

  final messageReply = Get.put(MessageReplyController()).message;

  void sendFileMessage(File file, MessageEnum messageEnum) {
    chatController.sendFileMessage(
        file: file,
        receiverUserId: widget.receiverUserId,
        senderUserData: widget.senderUser,
        messageEnum: messageEnum,
        messageReply: messageReply.value,
        isGroupChat: widget.IsGroupChat);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);

    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);

    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  // void sendTextMessage(
  //     BuildContext context, String text, String receiverUserId);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageReplyController>(
      builder: (messageReplyController) {
        RxBool isShowMessageReply =
            (messageReplyController.message.value == null ? false : true).obs;
        return Obx(
          () => Column(
            children: [
              isShowMessageReply.value
                  ? const MessageReplyPreview()
                  : const SizedBox(),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        focusNode: focusNode,
                        controller: _messageController,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        onChanged: (value) {
                          setState(() {
                            value.isNotEmpty
                                ? isShowSendButton = true
                                : isShowSendButton = false;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: mobileChatBoxColor,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              width: 50,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: toggleEmojiKeyboardContainer,
                                    icon: const Icon(
                                      Icons.emoji_emotions,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: const Icon(
                                  //     Icons.gif,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          suffixIcon: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: selectImage,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: selectVideo,
                                  icon: const Icon(
                                    Icons.attach_file,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            //instal
                          ),
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF128C7E),
                      radius: 25,
                      child: GestureDetector(
                        onTap: () async {
                          if (isShowSendButton) {
                            chatController.sendTextMessage(
                              text: _messageController.text.trim(),
                              receiverUserId: widget.receiverUserId,
                              senderUser: widget.senderUser,
                              messageReply: messageReply.value,
                              isGroupChat: widget.IsGroupChat,
                            );
                            setState(() {
                              _messageController.text = '';
                            });
                          } else {
                            var tempDir = await getTemporaryDirectory();
                            var path = '${tempDir.path}/flutter_sound.aac';
                            if (!isRecorderInit) {
                              return;
                            }
                            if (isRecording) {
                              await _soundRecorder!.stopRecorder();
                              sendFileMessage(File(path), MessageEnum.audio);
                            } else {
                              await _soundRecorder!.startRecorder(
                                toFile: path,
                              );
                            }
                            setState(() {
                              isRecording = !isRecording;
                            });
                          }
                        },
                        child: Icon(
                          isShowSendButton
                              ? Icons.send
                              : isRecording
                                  ? Icons.close
                                  : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isShowEmojiContainer
                  ? SizedBox(
                      height: 310,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          setState(() {
                            _messageController.text =
                                _messageController.text + emoji.emoji;
                          });
                          if (!isShowSendButton) {
                            setState(() {
                              isShowSendButton = true;
                            });
                          }
                        },
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
