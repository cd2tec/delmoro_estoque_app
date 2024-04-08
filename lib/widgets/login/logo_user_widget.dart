import 'package:flutter/material.dart';

class LogoUserWidget extends StatelessWidget {
  const LogoUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/logoUser.png',
      height: 50,
    );
  }
}
