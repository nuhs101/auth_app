import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Auth', home: AuthenticationScreen());
  }
}

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Auth Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[RegisterSignInWidget(auth: _auth)],
        ),
      ),
    );
  }
}

class RegisterSignInWidget extends StatefulWidget {
  final FirebaseAuth auth;

  const RegisterSignInWidget({super.key, required this.auth});

  @override
  State<RegisterSignInWidget> createState() => _RegisterSignInWidgetState();
}

class _RegisterSignInWidgetState extends State<RegisterSignInWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isRegistering = true;
  bool isSuccess = false;
  String? userEmail;

  void _submit() async {
    try {
      if (isRegistering) {
        await widget.auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await widget.auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }

      setState(() {
        isSuccess = true;
        userEmail = _emailController.text;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(auth: widget.auth),
        ),
      );
    } catch (e) {
      setState(() {
        isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isRegistering ? 'Register' : 'Sign In'),
        ),
        Text(isSuccess ? 'Success!' : 'Failed!'),
        TextButton(
          onPressed: () {
            setState(() {
              isRegistering = !isRegistering;
            });
          },
          child: Text(
            isRegistering
                ? 'Already have an account? Sign In'
                : 'Don\'t have an account? Register',
          ),
        ),
      ],
    );
  }
}
