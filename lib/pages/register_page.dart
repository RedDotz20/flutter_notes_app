import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_todo_app/pages/home_page.dart';
import 'package:flutter_todo_app/pages/login_page.dart';
import 'package:flutter_todo_app/widgets/registerWidgets/confirm_pass_field.dart';

import 'package:flutter_todo_app/widgets/registerWidgets/logo_widget.dart';
import 'package:flutter_todo_app/widgets/registerWidgets/password_field.dart';
import 'package:flutter_todo_app/widgets/loginWidgets/email_field.dart';
import 'package:flutter_todo_app/widgets/registerWidgets/headertext_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;
  bool _confirmObscureText = true;

  Future<void> register() async {
    final BuildContext currentContext = context; // Capture the context

    if (_formKey.currentState!.validate()) {
      try {
        debugPrint('New Username: ${newEmailController.text}');
        debugPrint('New Password: ${newPasswordController.text}');
        debugPrint('Confirm Password: ${confirmPasswordController.text}');

        final response = await http.post(
          Uri.parse('http://192.168.1.6:4000/register.php'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'username': newEmailController.text,
            'password': newPasswordController.text,
            'confirmPassword': confirmPasswordController.text,
          }),
        );

        if (response.statusCode == 200) {
          debugPrint('User registered successfully');
          Navigator.push(
            currentContext,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else {
          debugPrint('Failed to register user');
        }
      } catch (error) {
        debugPrint('Error: $error');

        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                const LogoWidget(),
                const HeaderTextWidget(),
                EmailField(
                    controller: newEmailController, labelText: "New Email"),
                PasswordFieldWidget(
                  controller: newPasswordController,
                  obscureText: _obscureText,
                  onPressed: (bool value) {
                    setState(() {
                      _obscureText = value;
                    });
                  },
                ),
                ConfirmPasswordWidget(
                  controller: confirmPasswordController,
                  obscureText: _confirmObscureText,
                  onPressed: (bool value) {
                    setState(() {
                      _confirmObscureText = value;
                    });
                  },
                ),
                _SignUpButton(
                  onPressed: () {
                    register();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => const HomePage()),
                    // );
                  },
                ),
                _SignInLink(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: const Text(
            'SIGN UP',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}

class _SignInLink extends StatelessWidget {
  const _SignInLink({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an Account? ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text(
            'SIGN IN',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}


// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController newUsernameController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   bool _obscureText = true;
//   bool _confirmObscureText = true;

//   Future<void> register() async {
//     final response = await http.post(
//       Uri.parse('http://your-api-url/register.php'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(<String, String>{
//         'username': newUsernameController.text,
//         'password': newPasswordController.text,
//         'confirmPassword': confirmPasswordController.text
//       }),
//     );

//     if (response.statusCode == 200) {
//       debugPrint('User registered successfully');
//     } else {
//       debugPrint('Failed to register user');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               const SizedBox(
//                 height: 20,
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 50.0),
//                 child: Center(
//                   child: SizedBox(
//                     width: 200,
//                     height: 150,
//                   ),
//                 ),
//               ),

//               const Padding(
//                 padding: EdgeInsets.only(bottom: 12.0),
//                 child: Text(
//                   "Create Your Account",
//                   style: TextStyle(
//                     fontSize: 35,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               // EMAIL FIELD
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                 child: TextField(
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     labelText: 'New Email',
//                     hintText: 'Enter New Email Address',
//                   ),
//                 ),
//               ),

//               // PASSWORD FIELD
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 15.0, right: 15.0, top: 15, bottom: 0),
//                 child: TextField(
//                   style: const TextStyle(color: Colors.white),
//                   obscureText: _obscureText,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     labelText: 'New Password',
//                     hintText: 'Enter secure password',
//                     suffixIcon: Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: IconButton(
//                         icon: Icon(
//                           _obscureText
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureText = !_obscureText;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // CONFIRM PASSWORD FIELD
//               ConfirmPasswordWidget(
//                 controller: confirmPasswordController,
//                 obscureText: _confirmObscureText,
//                 onPressed: (bool value) {
//                   setState(() {
//                     _confirmObscureText = value;
//                   });
//                 },
//               ),

//               Padding(
//                 padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
//                 child: Container(
//                   height: 50,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: TextButton(
//                     onPressed: () {
//                       // Call your register function here
//                       register();
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomePage()),
//                       );
//                     },
//                     child: const Text(
//                       'SIGN UP',
//                       style: TextStyle(color: Colors.white, fontSize: 25),
//                     ),
//                   ),
//                 ),
//               ),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Already have an Account? ",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const LoginPage()),
//                       );
//                     },
//                     child: const Text(
//                       'SIGN IN',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
