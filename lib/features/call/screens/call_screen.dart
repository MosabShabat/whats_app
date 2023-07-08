// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../config/agora_config.dart';
// import '../../../models/call.dart';
// import '../controller/callController.dart';

// class CallScreen extends StatefulWidget {
//   final String channelId;
//   final Call call;
//   final bool isGroupChat;
//   const CallScreen(
//       {super.key,
//       required this.channelId,
//       required this.call,
//       required this.isGroupChat});

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   var callController = Get.put(CallController());
//   AgoraClient? client;
//   String baseUrl = 'https://whatsapp-clone-rrr.herokuapp.com';
//   @override
//   void initState() {
//     super.initState();
//     client = AgoraClient(
//       agoraConnectionData: AgoraConnectionData(
//         appId: AgoraConfig.appId,
//         channelName: widget.channelId,
//         tokenUrl: baseUrl,
//       ),
//     );
//     initAgora();
//   }

//   void initAgora() async {
//     await client!.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: client == null
//           ? const CircularProgressIndicator()
//           : SafeArea(
//               child: Stack(
//                 children: [
//                   AgoraVideoViewer(client: client!),
//                   AgoraVideoButtons(
//                     client: client!,
//                     disconnectButtonChild: IconButton(
//                       onPressed: () async {
//                         await client!.engine.leaveChannel();
//                         callController.endCall(
//                           widget.call.callerId,
//                           widget.call.receiverId,
//                         );
//                         Get.back();
//                       },
//                       icon: const Icon(Icons.call_end),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
