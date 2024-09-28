import 'package:flutter/material.dart';
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

  // void generateTicket(String toStation, String fromStation){

  // }

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
              width: 100,
              // color: Colors.black,
              decoration: BoxDecoration(
                // color: Colors.black,
                border: Border.all(
                  color: const Color.fromARGB(41, 4, 47, 64),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('meow'),
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
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  StationDropDown(
                    onStationSelected: _onToStationSelect,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketCard(
                            fromStation: _selectedStationFrom!,
                            toStation: _selectedStationTo!),
                      ));
                },
                child: const Text('Book Ticket')),
          ],
        ),
      ),
    );
  }
}
