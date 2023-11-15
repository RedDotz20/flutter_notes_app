import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME PAGE'),
      ),
      body: Center(
        child: Container(
          height: 80,
          width: 150,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Welcome',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your FAB onPressed action here
        },
        tooltip: 'Add Item',
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
