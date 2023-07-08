import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whats_app/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: text.text.black.make(),
      style: ElevatedButton.styleFrom(
          primary: tabColor, minimumSize: const Size(double.infinity, 50)),
    );
  }
}
