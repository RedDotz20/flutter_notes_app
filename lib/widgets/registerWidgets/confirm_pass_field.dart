import 'package:flutter/material.dart';

class ConfirmPasswordWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Function(bool) onPressed;

  const ConfirmPasswordWidget({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmPasswordWidgetState createState() => _ConfirmPasswordWidgetState();
}

class _ConfirmPasswordWidgetState extends State<ConfirmPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        obscureText: widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          labelText: 'Confirm New Password',
          hintText: 'Re-enter New password',
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                widget.obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                widget.onPressed(!widget.obscureText);
              },
            ),
          ),
        ),
      ),
    );
  }
}
