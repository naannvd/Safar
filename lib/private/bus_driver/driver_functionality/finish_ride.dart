import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinishRideButton extends StatelessWidget {
  final String rideId;

  const FinishRideButton({super.key, required this.rideId});

  Future<void> _finishRide(BuildContext context) async {
    try {
      // Fetch the ride document by matching the ride_id
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('rides')
              .where('ride_id', isEqualTo: rideId)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> rideDoc =
            querySnapshot.docs.first;

        // Update the ride status to 'completed'
        await rideDoc.reference.update({'status': 'completed'});

        // Reset attributes for all children associated with the ride
        final List<dynamic> studentIds = rideDoc.data()?['students'] ?? [];
        for (String studentId in studentIds) {
          await FirebaseFirestore.instance
              .collection('childs')
              .doc(studentId)
              .update({
            'is_boarded': false,
            'is_champion': false,
            'is_present': false,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride finished successfully!')),
        );

        // Navigate back to the driver's dashboard
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Ride not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finishing ride: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button take full width
      height: 50, // Matches the height of the Scan QR Code button
      child: ElevatedButton(
        onPressed: () => _finishRide(context),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            const Color(0xFFA1CA73), // Matches the Scan QR Code button color
          ),
        ),
        child: const Text(
          'Finish Ride',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22, // Matches the Scan QR Code font size
            fontFamily: 'Montserrat', // Matches the font style
            color: Color(0xFF042F40), // Matches the Scan QR Code text color
          ),
        ),
      ),
    );
  }
}
