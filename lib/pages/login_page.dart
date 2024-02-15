import 'package:delmoro_estoque_app/services/api_service.dart';
import 'package:delmoro_estoque_app/services/auth_service.dart';
import 'package:delmoro_estoque_app/pages/home_page.dart';
import 'package:delmoro_estoque_app/services/database_service.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService service = AuthService();
  ApiService apiService = ApiService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(),
            const SizedBox(height: 16),
            UsernameInputWidget(
              controller: _usernameController,
              onChanged: _updateButtonState,
            ),
            const SizedBox(height: 16),
            PasswordInputWidget(
              controller: _passwordController,
              onChanged: _updateButtonState,
              obscureText: _obscurePassword,
              onToggle: _togglePasswordVisibility,
            ),
            const SizedBox(height: 24),
            LoginButtonWidget(
              onPressed:
                  _isButtonEnabled ? () => _authenticate(context) : () {},
              isEnabled: _isButtonEnabled,
            ),
          ],
        ),
      ),
    );
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _authenticate(BuildContext context) {
    DatabaseService.getToken().then((token) {
      if (token != null) {
        service
            .login(_usernameController.text, _passwordController.text, token)
            .then((result) {
          if (result.success) {
            final receivedToken = result.token!;
            apiService.getMe(receivedToken).then((userData) {
              final int userId = userData['id'];
              final String showCost = userData['showcost'];
              bool hasPermission = false;

              if (userData['grantedaccess'] == "1") {
                hasPermission = true;
              }

              apiService
                  .getPermission(receivedToken, userId)
                  .then((permissions) {
                if (hasPermission) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              username: _usernameController.text,
                              token: result.token!,
                              showCost: showCost,
                              permissions: permissions,
                            )),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text('Permissão negada'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Erro ao obter permissão'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text('Erro ao obter dados do usuário'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            });
          } else {
            _showSupportMessage(context);
          }
        });
      } else {
        var token = service.generateToken(
            _usernameController.text, _passwordController.text);

        DatabaseService.saveToken(token);
        service
            .login(_usernameController.text, _passwordController.text, token)
            .then((result) {
          if (result.success) {
            final receivedToken = result.token!;
            apiService.getMe(receivedToken).then((userData) {
              print('getme aqui $userData');

              final int userId = userData['id'];
              final String showCost = userData['showcost'];
              bool hasPermission = false;

              if (userData['grantedaccess'] == "1") {
                hasPermission = true;
              }

              apiService
                  .getPermission(receivedToken, userId)
                  .then((permissions) {
                print('hasPermission $permissions');
                if (hasPermission) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              username: _usernameController.text,
                              token: result.token!,
                              showCost: showCost,
                              permissions: permissions,
                            )),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text('Permissão negada'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Erro ao obter permissão'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text('Erro ao obter permissão'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            });
          } else {
            _showSupportMessage(context);
          }
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Erro ao buscar token do banco de dados'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _showSupportMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de login'),
          content: Text('Por favor, entre em contato com o suporte.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
