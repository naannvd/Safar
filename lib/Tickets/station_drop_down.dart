import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';

class StationDropDown extends StatefulWidget {
  const StationDropDown({
    super.key,
    required this.onStationSelected,
    required this.selectedLine,
  });

  final void Function(String) onStationSelected;
  final String selectedLine;

  @override
  _StationDropDownState createState() => _StationDropDownState();
}

class _StationDropDownState extends State<StationDropDown> {
  List<SelectedListItem> _stationItems = [];
  bool _isLoading = true;
  String? _selectedStation;

  @override
  void initState() {
    super.initState();
    _fetchStationNames();
  }

  // Fetch station names from Firestore
  Future<void> _fetchStationNames() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> stationsSnapshot =
          await FirebaseFirestore.instance
              .collection('stations')
              .where('metro_lines', isEqualTo: widget.selectedLine)
              .get();

      // Map the station names to SelectedListItem objects for the dropdown
      final List<SelectedListItem> stationNames = stationsSnapshot.docs
          .map((doc) => SelectedListItem(name: doc['station_name']))
          .toList();

      setState(() {
        _stationItems = stationNames;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching station names: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isLoading)
          const CircularProgressIndicator(), // Show loading indicator while fetching data
        if (!_isLoading && _stationItems.isNotEmpty)
          GestureDetector(
            onTap: () => _showDropdown(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 4, 47, 64),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedStation ?? 'Select a Station'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        if (!_isLoading && _stationItems.isEmpty)
          const Text('No stations available'),
      ],
    );
  }

  void _showDropdown() {
    DropDownState(
      DropDown(
        bottomSheetTitle: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Stations',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        data: _stationItems,
        selectedItems: (List<dynamic> selectedList) {
          if (selectedList.isNotEmpty) {
            setState(() {
              _selectedStation =
                  selectedList[0].name; // Update the selected station
            });
            widget.onStationSelected(_selectedStation!);
          }
        },
      ),
    ).showModal(context);
    FocusScope.of(context).unfocus(); // closes keyboard
  }
}
