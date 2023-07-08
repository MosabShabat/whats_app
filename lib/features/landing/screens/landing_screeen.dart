import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whats_app/features/auth/screens/login_screen.dart';
import 'package:whats_app/common/widgets/cusrom_button.dart';
import 'package:whats_app/constants/colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void getToLoginScreen(
    BuildContext context,
  ) {
    Get.to(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          50.heightBox,
          "Welcome to WhatsApp"
              .text
              .white
              .size(33)
              .fontWeight(FontWeight.w600)
              .make(),
          //70.heightBox,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              radius: 200,
              backgroundImage: AssetImage('assets/backgroundImage.png'),
            ),
          ),
          70.heightBox,
          Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                'Read uor Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.'
                    .text
                    .color(greyColor)
                    .center
                    .make(),
          ),
          10.heightBox,
          SizedBox(
            width: size.width * 0.75,
            child: CustomButton(
              text: "Agree and continue",
              onPressed: () => getToLoginScreen(context),
            ),
          )
        ],
      )),
    );
  }
}
