import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_app/features/auth/screens/login_screen.dart';
import 'package:whats_app/common/widgets/error.dart';
import 'package:whats_app/models/status_model.dart';
import 'package:whats_app/select_contant/screens/select_contacts_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/user_info_screen.dart';
import 'features/chat/screens/mobile_chat_screen.dart';
import 'features/group/screens/create_group_screen.dart';
import 'features/status/screens/confirm_status_screen.dart';
import 'features/status/screens/status_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInfoScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final IsGroupChat = arguments['IsGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          IsGroupChat: IsGroupChat,
          profilePic: profilePic,
        ),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;

      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );
    case StatusScreen.routeName:
      final status = settings.arguments as Status;

      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => CreateGroupScreen(),
      );
    //CreateGroupScreen
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: 'This page doesn\'t exist'),
              ));
  }
}
