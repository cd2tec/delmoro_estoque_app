// ignore_for_file: use_build_context_synchronously
import 'package:delmoro_estoque_app/widgets/login/clear_tokens_button_widget.dart';
import 'package:delmoro_estoque_app/widgets/login/login_button_widget.dart';
import 'package:delmoro_estoque_app/widgets/login/logo_widget.dart';
import 'package:delmoro_estoque_app/widgets/login/password_input_widget.dart';
import 'package:delmoro_estoque_app/widgets/login/username_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:delmoro_estoque_app/services/api_service.dart';
import 'package:delmoro_estoque_app/services/auth_service.dart';
import 'package:delmoro_estoque_app/pages/home_page.dart';
import 'package:delmoro_estoque_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String? savedUsername;
  final String? savedPassword;

  const LoginPage({Key? key, this.savedUsername, this.savedPassword})
      : super(key: key);

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    if (widget.savedUsername != null && widget.savedPassword != null) {
      setState(() {
        _usernameController.text = widget.savedUsername!;
        _passwordController.text = widget.savedPassword!;
        _isButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const LogoWidget(),
            ),
            const SizedBox(height: 14),
            UsernameInputWidget(
              controller: _usernameController,
              onChanged: _updateButtonState,
            ),
            const SizedBox(height: 14),
            PasswordInputWidget(
              controller: _passwordController,
              onChanged: _updateButtonState,
              obscureText: _obscurePassword,
              onToggle: _togglePasswordVisibility,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : LoginButtonWidget(
                    onPressed: _isButtonEnabled ? () => _authenticate() : () {},
                    isEnabled: _isButtonEnabled,
                  ),
            const SizedBox(height: 16),
            ClearTokensButtonWidget(
              onPressed: () => _showConfirmationDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    if (!mounted) return;

    BuildContext? dialogContext = context;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Deseja limpar os dados do app?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext!).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                Navigator.of(dialogContext!).pop();
                await _clearToken();
                if (mounted) {
                  showDialog(
                    context: dialogContext!,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Limpeza de dados finalizada'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearToken() async {
    await DatabaseService.deleteToken();
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

  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;
    try {
      final token = await DatabaseService.getToken(username);

      if (token != null) {
        final result = await service.login(
            _usernameController.text, _passwordController.text, token);
        if (result.success) {
          final receivedToken = result.token!;
          final userData = await apiService.getMe(receivedToken);
          final int userId = userData['id'];
          final String showCost = userData['showcost'];
          bool hasPermission = false;

          if (userData['grantedaccess'] == "1") {
            hasPermission = true;
          }

          final permissions =
              await apiService.getPermission(receivedToken, userId);

          if (hasPermission) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', username);
            await prefs.setString('password', password);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  username: _usernameController.text,
                  token: receivedToken,
                  showCost: showCost,
                  permissions: permissions,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                    'Permissão negada. Entre em contato com o administrador'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          _showSupportMessage(context);
        }
      } else {
        final token = service.generateToken(
            _usernameController.text, _passwordController.text);

        await DatabaseService.saveToken(_usernameController.text, token);
        final result = await service.login(
            _usernameController.text, _passwordController.text, token);
        if (result.success) {
          final receivedToken = result.token!;
          final userData = await apiService.getMe(receivedToken);
          final int userId = userData['id'];
          final String showCost = userData['showcost'];
          bool hasPermission = false;

          if (userData['grantedaccess'] == "1") {
            hasPermission = true;
          }

          final permissions =
              await apiService.getPermission(receivedToken, userId);

          if (hasPermission) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  username: _usernameController.text,
                  token: receivedToken,
                  showCost: showCost,
                  permissions: permissions,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                    'Permissão negada. Entre em contato com o administrador para liberar o acesso.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          _showSupportMessage(context);
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Erro durante a autenticação: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSupportMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de login'),
          content: Text('Verifique suas credenciais.'),
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
