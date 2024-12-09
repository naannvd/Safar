import 'package:flutter/material.dart';

class StationInfoWidget extends StatelessWidget {
  final Map<String, dynamic> station;

  const StationInfoWidget({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(Icons.train, color: Colors.blue),
          const SizedBox(width: 10),
          Text('${station['name']}'),
        ],
      ),
    );
  }
}
