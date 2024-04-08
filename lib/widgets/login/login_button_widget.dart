import 'package:flutter/material.dart';

class LoginButtonWidget extends StatelessWidget {
  final Function onPressed;
  final bool isEnabled;

  const LoginButtonWidget(
      {super.key, required this.onPressed, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? () => onPressed() : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text('Acessar'),
    );
  }
}
