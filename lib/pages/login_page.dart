import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

import "../widgets/loginWidgets/email_field.dart";
import "../widgets/loginWidgets/password_field.dart";
import "../widgets/loginWidgets/submit_button.dart";
import "../widgets/loginWidgets/sign_up_link.dart";
import "../pages/home_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _obscureText = true;

  Future<void> login() async {
    final BuildContext currentContext = context; // Capture the context

    final username = usernameController.text;
    final password = passwordController.text;

    debugPrint(username);
    debugPrint(password);

    const String apiUrl = "http://192.168.1.6:4000/login.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Successful login, handle the response as needed
        debugPrint('Login successful!');
        debugPrint('Response: ${response.body}');

        // Example navigation to home page after successful login
        Navigator.push(
          currentContext,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        // Handle errors or unsuccessful login
        debugPrint('Login failed. Status code: ${response.statusCode}');
        debugPrint('Response: ${response.body}');

        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    } catch (error) {
      // Handle network errors or exceptions
      debugPrint('Error: $error');

      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: LoginForm(
            formKey: _formKey,
            usernameController: usernameController,
            passwordController: passwordController,
            obscureText: _obscureText,
            onLoginPressed: login,
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.obscureText,
    required this.onLoginPressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscureText;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: SizedBox(
              width: 200,
              height: 150,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              "Login Your Account",
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // ... other widgets
          EmailField(
            controller: usernameController,
            labelText: "Email",
          ),
          PasswordField(
            controller: passwordController,
            obscureText: obscureText,
          ),
          SubmitButton(onPressed: onLoginPressed),
          const SignUpLink(),
        ],
      ),
    );
  }
}
