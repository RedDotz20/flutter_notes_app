import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField(
      {super.key, required this.controller, required this.obscureText});

  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 15,
        bottom: 0,
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          labelText: 'Password',
          hintText: 'Enter secure password',
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                // Toggle the password visibility
                // (This logic should probably be extracted as well)
                // For simplicity, I'm keeping it here.
                // Alternatively, you can create a separate widget for the suffix icon.
                (context as Element).markNeedsBuild();
              },
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          // Add more validation logic if needed
          return null;
        },
      ),
    );
  }
}
