import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "../services/auth.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  bool isLogin = true;
  bool obscureText = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    final BuildContext currentContext = context; //
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.message}"),
          ),
        );
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    final BuildContext currentContext = context; // Store the context

    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.message}"),
          ),
        );
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller) {
    bool isPassword = title.toLowerCase() == 'password';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: isPassword ? obscureText : false,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(color: Colors.white),
          hintText: 'Enter your $title',
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _authStatusText() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          isLogin ? "Login Your Account" : "Create your account",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            isLogin
                ? signInWithEmailAndPassword()
                : createUserWithEmailAndPassword();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Adjust the border radius
            ),
          ),
          child: Text(
            isLogin ? "LOGIN" : "REGISTER",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin
            ? "Don't have an account? Register here"
            : "Already have an account? Login here",
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _headerIcon() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: const Icon(
        Icons.edit_note,
        size: 100.0,
        color: Colors.white,
      ),
    );
  }

  Widget _subHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: const Text(
        "Notes App",
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(title: _title()),
        body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0), // Adjust as needed
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _headerIcon(),
                  _subHeader(),
                  _authStatusText(),
                  _entryField("Email", _controllerEmail),
                  _entryField("Password", _controllerPassword),
                  // _errorMessage(),
                  _submitButton(),
                  _loginOrRegisterButton(),
                ],
              ),
            )));
  }
}
