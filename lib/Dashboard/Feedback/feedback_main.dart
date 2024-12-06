import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackIcon extends StatelessWidget {
  const FeedbackIcon(
      {super.key, required this.foregroundColor, required this.ticketId});
  final Color foregroundColor;
  final String ticketId;

  @override
  Widget build(BuildContext context) {
    Future<String> getUserName(BuildContext context) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception("User not logged in");
        }
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userData.data() == null ||
            !userData.data()!.containsKey('fullName')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User full name not found!')),
          );
          throw Exception("Full name not found in user data");
        }
        return userData['fullName'];
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        return 'Unknown User';
      }
    }

    return GestureDetector(
      onTap: () {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String message = "";
          QuickAlert.show(
            context: context,
            type: QuickAlertType.custom,
            barrierDismissible: true,
            confirmBtnText: 'Submit',
            confirmBtnTextStyle: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF042F42),
            ),
            confirmBtnColor: const Color(0xFFA1CA73),
            customAsset: 'assets/images/mamad.jpg',
            widget: TextFormField(
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                hintText: 'Enter Feedback',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: Icon(
                  Icons.feedback,
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              onChanged: (value) => message = value,
            ),
            onConfirmBtnTap: () async {
              if (message.length < 5) {
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: 'Please input something',
                );
                return;
              }
              Navigator.pop(context);
              await Future.delayed(const Duration(milliseconds: 1000));
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: "Feedback has been saved!",
                confirmBtnTextStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF042F42),
                ),
                confirmBtnColor: const Color(0xFFA1CA73),
              );

              // Fetch the username
              final userName = await getUserName(context);

              // Save feedback to Firestore
              await FirebaseFirestore.instance.collection('feedback').add({
                'ticketId': ticketId,
                'message': message,
                'createdAt': Timestamp.now(),
                'userId': user.uid,
                'userName': userName,
              });
            },
            title: 'Have Complaints?',
            titleColor: const Color(0xFF042F42),
          );
        }
      },
      child: Icon(
        Icons.more_vert,
        color: foregroundColor,
      ),
    );
  }
}
