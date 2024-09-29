import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/Tickets/station_drop_down.dart';
import 'package:safar/Tickets/ticket.dart';
import 'package:safar/Tickets/ticket_support.dart';
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
  int? fare;

  // Map for metro lines and their corresponding colors
  final Map<String, Color> lineColors = {
    'Blue-Line': const Color(0xFF3E7C98),
    'Red-Line': const Color(0xFFCC3636),
    'Green-Line': const Color(0xFFA1CA73),
    'Orange-Line': const Color(0xFFE06236),
  };

  // List of metro lines
  final List<String> metroLines = [
    'Blue-Line',
    'Red-Line',
    'Green-Line',
    'Orange-Line'
  ];

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
    if (line != null) {
      _fetchFare(line);
    }
  }

  Future<void> _fetchFare(String lineName) async {
    try {
      // Fetch fare from Firestore
      TicketSupport ticketSupport = TicketSupport();
      int _fetchedFare = await ticketSupport.getFare(lineName);
      setState(() {
        fare = _fetchedFare;
      });
    } catch (e) {
      // Display an error message if fare is not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching fare. Please try again.'),
        ),
      );
    }
  }

  Future<String?> getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
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
            // Metro Line Dropdown
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
            // Conditionally render Station Dropdowns or prompt user to select a line
            if (_selectedLine == null)
              Container(
                alignment: Alignment.center,
                height: 40,
                width: 200,
                // decoration: BoxDecoration(
                //   color: Colors.grey[300],
                //   border: Border.all(
                //     color: const Color.fromARGB(41, 4, 47, 64),
                //     width: 2,
                //   ),
                //   borderRadius: BorderRadius.circular(20),
                // ),
                child: const Text(
                  'Select a line',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            else ...[
              // From Station Dropdown
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    StationDropDown(
                      onStationSelected: _onFromStationSelect,
                      selectedLine: _selectedLine!, // Pass the selected line
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    StationDropDown(
                      onStationSelected: _onToStationSelect,
                      selectedLine: _selectedLine!, // Pass the selected line
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(
              height: 30,
            ),
            if (_selectedLine != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedLine != null
                      ? lineColors[_selectedLine]
                      : Colors.grey[300],
                ),
                onPressed: () async {
                  if (_selectedStationFrom != null &&
                      _selectedStationTo != null &&
                      _selectedLine != null) {
                    // Check if fare is available
                    if (fare == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Fare not available. Please select a valid metro line.'),
                        ),
                      );
                      return; // Exit if fare is not available
                    }

                    try {
                      // Fetch the userId
                      String? receivedUserId = await getUserId();

                      if (receivedUserId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'User not logged in. Please log in to book a ticket.'),
                          ),
                        );
                        return; // Exit if userId is null
                      }

                      // Create the ticket
                      await TicketSupport().createTicket(
                        userId: receivedUserId,
                        fromStation: _selectedStationFrom!,
                        toStation: _selectedStationTo!,
                        routeName: _selectedLine!,
                        fare: fare!,
                        timeToNext: 10,
                      );

                      // Navigate to TicketCard page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketCard(
                            fromStation: _selectedStationFrom!,
                            toStation: _selectedStationTo!,
                          ),
                        ),
                      );
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error booking ticket: $e')),
                      );
                    }
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
                    fontSize: 20,
                    color: _selectedLine != null ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
