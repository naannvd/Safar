import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddChildDashboard extends StatefulWidget {
  const AddChildDashboard({super.key});

  @override
  State<AddChildDashboard> createState() => _AddChildDashboardState();
}

class _AddChildDashboardState extends State<AddChildDashboard> {
  final _formSignupKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUpUser() async {
    if (_formSignupKey.currentState!.validate()) {
      try {
        // Get current parent credentials
        final parentUser = FirebaseAuth.instance.currentUser!;
        final parentEmail = parentUser.email; // Parent email
        final parentUid = parentUser.uid; // Parent UID
        final parentPassword =
            await promptParentForPassword(); // Prompt for password

        if (parentPassword == null || parentEmail == null) {
          throw Exception("Parent credentials are missing.");
        }

        // Ensure current user is signed out before creating a new user
        await FirebaseAuth.instance.signOut();

        // Create child user with Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Get the UID of the newly created child user
        String childUid = userCredential.user!.uid;

        // Log out the child user and reauthenticate the parent
        await FirebaseAuth.instance.signOut();

        try {
          // Re-authenticate the parent user
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: parentEmail,
            password: parentPassword,
          );
        } on FirebaseAuthException catch (e) {
          // If parent re-authentication fails, delete the created child account
          await FirebaseAuth.instance.currentUser?.delete();
          throw Exception(
              "Parent re-authentication failed. Child account deleted.");
        }

        // Store child details in Firestore
        await FirebaseFirestore.instance
            .collection('childs')
            .doc(childUid) // Use the UID as the document ID
            .set({
          'child_name': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': Timestamp.now(),
          'role': 'Child',
          'is_boarded': false,
          'is_champion': false,
          'is_present': false,
          'parent_id': parentUid, // Parent UID
          'child_id': childUid, // Use the UID as the child_id
        });

        // Update parent collection with child ID
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(parentUid)
            .update({
          'children': FieldValue.arrayUnion([childUid]),
        });

        // Success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Child account created successfully!')),
        );

        // Clear fields after successful signup
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The password provided is too weak.')),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('The account already exists for that email.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<String?> promptParentForPassword() async {
    String? password;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController passwordController =
            TextEditingController();
        return AlertDialog(
          title: const Text("Re-authentication Required"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please enter your password to continue."),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                password = null; // Cancel
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                password = passwordController.text.trim();
                Navigator.of(context).pop();
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
    return password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Child Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formSignupKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _signUpUser,
                  child: const Text('Add Child'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
