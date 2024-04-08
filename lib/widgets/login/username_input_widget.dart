import 'package:flutter/material.dart';

class UsernameInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;

  const UsernameInputWidget(
      {super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Usuário',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (value) => onChanged(),
    );
  }
}
