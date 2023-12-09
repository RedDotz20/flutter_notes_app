import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: Center(
        child: SizedBox(
          width: 200,
          height: 150,
        ),
      ),
    );
  }
}
