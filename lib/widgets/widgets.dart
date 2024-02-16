import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/logoMobile.png',
      height: 200,
    );
  }
}

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
