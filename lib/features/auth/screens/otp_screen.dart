import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/colors.dart';
import '../controller/auth_controller.dart';

class OTPScreen extends StatelessWidget {
  static const routeName = '/otp-screen';
  final String verificationId;

  const OTPScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var controller = Get.put(AuthController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: 'Verifying your number'.text.white.size(20).make(),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.heightBox,
            'We have sent as SMS with a code'.text.size(18).white.make(),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                controller: controller.verificationController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: '- - - - - -',
                    hintStyle: TextStyle(
                      fontSize: 30,
                    )),
                onChanged: (value) async {
                  if (value.trim().length == 6) {
                    print('==============welcome==============');
                    controller.verifyOTP(
                      context: context,
                      verificationId: verificationId,
                      userOTP: value.trim(),
                    );
                    print('===============out==============');
                  }
                },
              ),
            ),
            // SizedBox(height: size.height * 0.6),
            // SizedBox(
            //   width: 90,
            //   child: CustomButton(
            //     text: 'NEXT',
            //     onPressed: () async {
            //       if (controller.verificationController.text.length == 6) {
            //         print('welcome');
            //         controller.verifyOTP(context: context, userOTP: '123456');
            //       }
            //       print('===============out==============');
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
