// ignore_for_file: library_private_types_in_public_api
import 'package:delmoro_estoque_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delmoro_estoque_app/pages/login_page.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;

  final prefs = await SharedPreferences.getInstance();
  final savedUsername = prefs.getString('username');
  final savedPassword = prefs.getString('password');

  runApp(MyApp(savedUsername: savedUsername, savedPassword: savedPassword));
}

class MyApp extends StatelessWidget {
  final String? savedUsername;
  final String? savedPassword;

  const MyApp({Key? key, this.savedUsername, this.savedPassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(
        nextPage: LoginPage(
            savedUsername: savedUsername, savedPassword: savedPassword),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen({Key? key, required this.nextPage}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    timeDilation = 1.5;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget.nextPage,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: const LogoWidget(),
        ),
      ),
    );
  }
}
