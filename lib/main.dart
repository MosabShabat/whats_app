import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/constants/firebase_consts.dart';
import 'package:whats_app/router.dart';
import 'package:whats_app/mobile_layout_screen.dart';
import 'package:whats_app/splash_screen.dart';
import 'common/widgets/error.dart';
import 'features/auth/controller/auth_controller.dart';
import 'constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/landing/screens/landing_screeen.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    // print('===============here===============');
    // print(controller.getCurrentUserData());
    // print('===============here===============');
    print('===============here isLoading===============');
    print(controller.isLoading);
    print('===============here isLoading===============');

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp UI',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: const AppBarTheme(
              color: appBarColor,
            )),
        // onGenerateRoute: AppRoutes.generateRoute,
        home: const SeplashScreen()

        // StreamBuilder<UserModel>(
        //   stream: controller.userData(currentUser!.uid),
        //   builder: (context, snapshot) {
        //     // if (snapshot.hasError) {
        //     //   return ErrorScreen(
        //     //     error: snapshot.error.toString(),
        //     //   );
        //     // }

        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const CircularProgressIndicator();
        //     }

        //     final user = snapshot.data;
        //     if (user == null) {
        //       return const LandingScreen();
        //     } else {
        //       return const MobileLayoutScreen();
        //     }
        //   },
        // ),
        );
  }
}

class AppRoutes {
  static const String landing = '/';
  static const String mobileLayout = '/mobile-layout';
  static const String error = '/error';
  static const String loader = '/loader';

  static final List<GetPage> routes = [
    GetPage(name: landing, page: () => LandingScreen()),
    GetPage(name: mobileLayout, page: () => MobileLayoutScreen()),
    GetPage(name: loader, page: () => CircularProgressIndicator()),
  ];

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Add more routes as needed
      default:
        return null;
    }
  }
}
