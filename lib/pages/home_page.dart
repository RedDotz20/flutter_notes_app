import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/services/firestore.dart';
import 'package:todo_app/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? errorMessage = "";
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController textController = TextEditingController();

  Future<void> signOutAccount() async {
    try {
      await Auth().signOut();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // open dialog box to add note
  void openNoteBox(
      {String? docID, String action = "add", String? defaultNote}) {
    textController.text = defaultNote ?? "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
        title: Text(
            action == "add" ? "Add Note" : "Update Note"), // Add a title here
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue), // Set the underline color to blue
            ),
          ),
          cursorColor: Colors.blue,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Cancel button action
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              // backgroundColor: Colors.grey, // Set the button color to grey
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5.0), // Minimal border radius
              ),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // add note to firestore
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }

              // update an existing note
              else {
                firestoreService.updateNote(
                  docID,
                  textController.text,
                );
              }

              // clear the text controller
              textController.clear();

              //close the box
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Set the button color to blue
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5.0), // Minimal border radius
              ),
            ),
            child: Text(
              action == "add" ? "ADD" : "UPDATE",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Notes List",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            User? user = snapshot.data;

            if (user != null) {
              return Column(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: const Text("Logged In As"),
                    accountEmail: Text(user.email ?? "user@example.com"),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.blue, // Set your desired color here
                    ),
                  ),
                  const Spacer(),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () {
                      // Handle logout press
                      signOutAccount();
                      // You can add your logout logic here
                    },
                  ),
                ],
              );
            } else {
              return const ListTile(
                title: Text('Not signed in'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(),
        backgroundColor: Colors.blue,
        tooltip: 'Add Note',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // if we have data, get all the docs
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            // display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                // display as a list title
                return ListTile(
                  title: Text(
                    noteText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // update button
                      IconButton(
                        onPressed: () => openNoteBox(
                            docID: docID,
                            action: "update",
                            defaultNote: noteText),
                        icon: const Icon(Icons.edit),
                        color: Colors.white,
                      ),

                      // delete button
                      IconButton(
                          onPressed: () => firestoreService.deleteNote(
                                docID,
                              ),
                          icon: const Icon(Icons.delete),
                          color: Colors.red),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("No Notes...");
          }
        },
      ),
    );
  }
}
