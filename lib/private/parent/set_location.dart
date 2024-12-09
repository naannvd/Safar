import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetLocationScreen extends StatefulWidget {
  final String parentId;

  const SetLocationScreen({super.key, required this.parentId});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  LatLng? _selectedLocation;
  late GoogleMapController _mapController;

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  Future<void> _saveLocation() async {
    if (_selectedLocation != null) {
      try {
        await FirebaseFirestore.instance
            .collection('parent_locations')
            .doc(widget.parentId)
            .set({
          'parent_id': widget.parentId,
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location saved successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save location.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Location"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: _onMapTap,
            initialCameraPosition: const CameraPosition(
              target: LatLng(33.6844, 73.0479), // Default location (Islamabad)
              zoom: 14,
            ),
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _saveLocation,
              child: const Text("Save Location"),
            ),
          ),
        ],
      ),
    );
  }
}
