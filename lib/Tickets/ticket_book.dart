import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/Tickets/station_drop_down.dart';
import 'package:safar/Tickets/ticket.dart';
import 'package:safar/Widgets/bottom_nav_bar.dart';

class TicketBook extends StatefulWidget {
  const TicketBook({super.key});

  @override
  State<TicketBook> createState() => _TicketBookState();
}

class _TicketBookState extends State<TicketBook> {
  String? _selectedStationFrom;
  String? _selectedStationTo;
  String? _selectedLine;

  // Map for metro lines and their corresponding colors
  final Map<String, Color> lineColors = {
    'Blue': const Color(0xFF3E7C98),
    'Red': const Color(0xFFCC3636),
    'Green': const Color(0xFFA1CA73),
    'Orange': const Color(0xFFE06236),
  };

  // List of metro lines
  final List<String> metroLines = ['Blue', 'Red', 'Green', 'Orange'];

  void _onFromStationSelect(String station) {
    setState(() {
      _selectedStationFrom = station;
    });
  }

  void _onToStationSelect(String station) {
    setState(() {
      _selectedStationTo = station;
    });
  }

  void _onLineSelect(String? line) {
    setState(() {
      _selectedLine = line;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const RoundedNavBar(currentTab: 'Ticket'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ticket Book',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: _selectedLine != null
                    ? lineColors[_selectedLine]
                    : Colors.grey[300], // Change color based on selected line
                border: Border.all(
                  color: const Color.fromARGB(41, 4, 47, 64),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton<String>(
                value: _selectedLine,
                hint: Text(
                  'Select Line',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                dropdownColor: _selectedLine != null
                    ? lineColors[_selectedLine] // Change dropdown color
                    : Colors.grey[300],
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                underline: Container(), // Remove the default underline
                onChanged: _onLineSelect,
                style: const TextStyle(
                  // Set the style for the selected text
                  color: Colors.white, // Change selected text color to white
                  fontSize: 16,
                ),
                items: metroLines.map((String line) {
                  return DropdownMenuItem<String>(
                    value: line,
                    child: Text(
                      line,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: _selectedLine == null
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  StationDropDown(
                    onStationSelected: _onFromStationSelect,
                    selectedLine: _selectedLine!,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  StationDropDown(
                    onStationSelected: _onToStationSelect,
                    selectedLine: _selectedLine!,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedLine != null
                      ? lineColors[_selectedLine]
                      : Colors.grey[300], //
                ),
                onPressed: () {
                  if (_selectedStationFrom != null &&
                      _selectedStationTo != null &&
                      _selectedLine != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketCard(
                            fromStation: _selectedStationFrom!,
                            toStation: _selectedStationTo!),
                      ),
                    );
                  } else {
                    // Display an error message if any field is not selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a line and stations.'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Book Ticket',
                  style: GoogleFonts.montserrat(
                      // Change text color based on selected line
                      fontSize: 20,
                      color:
                          _selectedLine != null ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w400),
                )),
          ],
        ),
      ),
    );
  }
}
