// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../models/call.dart';
// import '../controller/callController.dart';
// import 'call_screen.dart';

// class CallPickupScreen extends StatelessWidget {
//   final Widget scaffold;
//   const CallPickupScreen({
//     super.key,
//     required this.scaffold,
//   });

//   @override
//   Widget build(BuildContext context) {
//     var callController = Get.put(CallController());

//     return StreamBuilder<DocumentSnapshot>(
//       stream: callController.callStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData && snapshot.data!.data() != null) {
//           Call call =
//               Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

//           if (!call.hasDialled) {
//             return Scaffold(
//               body: Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Incoming Call',
//                       style: TextStyle(
//                         fontSize: 30,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 50),
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(call.callerPic),
//                       radius: 60,
//                     ),
//                     const SizedBox(height: 50),
//                     Text(
//                       call.callerName,
//                       style: const TextStyle(
//                         fontSize: 25,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                     const SizedBox(height: 75),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed: () {},
//                           icon: const Icon(Icons.call_end,
//                               color: Colors.redAccent),
//                         ),
//                         const SizedBox(width: 25),
//                         IconButton(
//                           onPressed: () {
//                             // Get.to(
//                             //     () => MaterialPageRoute(
//                             //           builder: (context) => CallScreen(
//                             //             channelId: call.callId,
//                             //             call: call,
//                             //             isGroupChat: false,
//                             //           ),
//                             //         ),
//                             //     transition: Transition.downToUp);
//                           },
//                           icon: const Icon(
//                             Icons.call,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         }
//         return scaffold;
//       },
//     );
//   }
// }
