import 'package:flutter/material.dart';

class PasswordInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;
  final bool obscureText;
  final Function onToggle;

  const PasswordInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.obscureText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Senha',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => onToggle(),
        ),
      ),
      obscureText: obscureText,
      onChanged: (value) => onChanged(),
    );
  }
}
