import 'package:flutter/material.dart';

class ClearTokensButtonWidget extends StatelessWidget {
  final Function onPressed;

  const ClearTokensButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.grey[850],
      ),
      child: const Text('Problemas ao acessar? Clique para resetar o app',
          style: TextStyle(fontSize: 12)),
    );
  }
}
