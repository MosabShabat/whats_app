import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whats_app/features/auth/controller/auth_controller.dart';
import 'package:whats_app/common/widgets/cusrom_button.dart';
import 'package:whats_app/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;
  var controller = Get.put(AuthController());

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: 'Enter your phone number'.text.white.size(20).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            'WhatsApp will need to verify your phone number'
                .text
                .white
                .size(18)
                .make(),
            10.heightBox,
            TextButton(
              onPressed: pickCountry,
              child: 'Pick Country'.text.color(Colors.blue).size(18).make(),
            ),
            5.heightBox,
            Row(
              children: [
                if (country != null)
                  '+${country!.phoneCode}'.text.white.size(18).make(),
                10.widthBox,
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'phone number'),
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.5),
            SizedBox(
              width: 90,
              child: CustomButton(
                text: 'NEXT',
                onPressed: () async {
                  controller.isLoading(true);
                  await controller
                      .signInWithPhone(
                          context: context,
                          phoneNumber:
                              '+${country!.phoneCode}${phoneController.text}')
                      .then((value) {
                    if (value != null) {
                      VxToast.show(context, msg: "Logged in successfully");
                      //  Get.offAll(() => MobileChatScreen());
                    } else {
                      controller.isLoading(false);
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
