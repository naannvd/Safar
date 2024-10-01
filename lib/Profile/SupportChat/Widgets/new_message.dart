import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); // closes keyboard
    _messageController.clear();
    //send to firebase
    final user = FirebaseAuth.instance.currentUser!;

    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      print(user.uid);
      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['fullName'],
        'userImage': userData.data()!['image_url'],
      });
      print("Text sent");
    } catch (e) {
      print("error $e");
    }
    _messageController.clear(); // resets input
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                label: Text(
                  'Send a text...',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF042F42),
                    fontSize: 21,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.send),
            onPressed: _submitMessage,
          )
        ],
      ),
    );
  }
}
