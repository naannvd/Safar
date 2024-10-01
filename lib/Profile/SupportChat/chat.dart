import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:safar/Profile/SupportChat/Widgets/chat_messages.dart';
import 'package:safar/Profile/SupportChat/Widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotif() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    final token = await fcm.getToken();
    fcm.subscribeToTopic('chat');
    print("token $token");
  }

  @override
  void initState() {
    super.initState();
    setupPushNotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Chat with Users',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: const Column(
        children: [Expanded(child: ChatMessages()), NewMessage()],
      ),
    );
  }
}
