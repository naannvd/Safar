import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // title: const Text('Dashboard'),
      //     ),
      body: Row(
        children: [
          // Persistent Sidebar
          Container(
            width: 250, // Fixed width for sidebar
            decoration: const BoxDecoration(color: Color(0xFF2a4574)),

            child: Column(
              children: [
                // Container(
                //   child: Icon(Icons.person, color: Colors.white),
                // ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  // color: Colors.blue,
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text("SA"),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Syed Areeb",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "admin@safar.com",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    children: const [
                      SidebarTile(
                        icon: Icons.dashboard,
                        title: 'Dashboard',
                      ),
                      SidebarTile(
                        icon: Icons.route,
                        title: 'Routes',
                      ),
                      SidebarTile(
                        icon: Icons.people,
                        title: 'User',
                      ),
                      SidebarTile(
                        icon: Icons.directions_bus,
                        title: 'Trip',
                      ),
                      SidebarTile(
                        icon: Icons.notifications,
                        title: 'Notifications',
                      ),
                      SidebarTile(
                        icon: Icons.inbox,
                        title: 'Inbox',
                      ),
                      SidebarTile(
                        icon: Icons.bar_chart,
                        title: 'Reports',
                      ),
                      SidebarTile(
                        icon: Icons.settings,
                        title: 'Settings',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.all(16),
                            child:
                                const Center(child: Text("Chart Placeholder")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                                child: Text("Calendar Placeholder")),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            height: 150,
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                                child: Text("Recent Tickets Placeholder")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            height: 150,
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                                child: Text("Recent Feedback Placeholder")),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 4,
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(16),
                            child: const Center(
                                child: Text("Contacts Placeholder")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SidebarTile Widget for consistency
class SidebarTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const SidebarTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        // Handle navigation or actions here
      },
    );
  }
}
