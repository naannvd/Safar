import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<double> calculateMonthlyRevenue() async {
    try {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);

      final snapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .where('purchaseTime', isGreaterThanOrEqualTo: firstDayOfMonth)
          .get();

      double totalRevenue = 0.0;
      for (var doc in snapshot.docs) {
        final fare = (doc.data()['fare'] ?? 0.0) as double;
        totalRevenue += fare;
      }

      return totalRevenue;
    } catch (e) {
      print("Error calculating revenue: $e");
      return 0.0;
    }
  }

  Future<int> countTotalUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return snapshot.docs.length;
    } catch (e) {
      print("Error counting users: $e");
      return 0;
    }
  }

  Future<int> countTotalStations() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('stations').get();
      return snapshot.docs.length;
    } catch (e) {
      print("Error counting stations: $e");
      return 0;
    }
  }

  Future<Map<DateTime, int>> fetchDailyUserGrowth() async {
    try {
      final now = DateTime.now();
      final lastMonth = now.subtract(const Duration(days: 30));
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('createdAt', isGreaterThanOrEqualTo: lastMonth)
          .get();

      final dailyGrowth = <DateTime, int>{};

      for (var doc in snapshot.docs) {
        final createdAt = (doc.data()['createdAt'] as Timestamp).toDate();
        final date = DateTime(createdAt.year, createdAt.month, createdAt.day);
        dailyGrowth[date] = (dailyGrowth[date] ?? 0) + 1;
      }

      return dailyGrowth;
    } catch (e) {
      print("Error fetching daily user growth: $e");
      return {};
    }
  }

  Future<Map<int, int>> fetchMonthlyUserGrowth() async {
    try {
      final now = DateTime.now();
      final lastYear = now.subtract(const Duration(days: 365));
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('createdAt', isGreaterThanOrEqualTo: lastYear)
          .get();

      final monthlyGrowth = <int, int>{};

      for (var doc in snapshot.docs) {
        final createdAt = (doc.data()['createdAt'] as Timestamp).toDate();
        final month = createdAt.month;
        monthlyGrowth[month] = (monthlyGrowth[month] ?? 0) + 1;
      }

      return monthlyGrowth;
    } catch (e) {
      print("Error fetching monthly user growth: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Upper section
          Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            color: const Color(0xFFA1CA73),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<double>(
                    future: calculateMonthlyRevenue(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingSection();
                      }
                      final revenue = snapshot.data ?? 0.0;
                      return _buildDashboardSection(
                        icon: Icons.attach_money,
                        title: 'Revenue this month',
                        value: 'PKR ${revenue.toStringAsFixed(2)}',
                      );
                    },
                  ),
                  FutureBuilder<int>(
                    future: countTotalUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingSection();
                      }
                      final totalUsers = snapshot.data ?? 0;
                      return _buildDashboardSection(
                        icon: Icons.person,
                        title: 'Total Users',
                        value: '$totalUsers',
                      );
                    },
                  ),
                  FutureBuilder<int>(
                    future: countTotalStations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingSection();
                      }
                      final totalStations = snapshot.data ?? 0;
                      return _buildDashboardSection(
                        icon: Icons.location_on,
                        title: 'Total Stations',
                        value: '$totalStations',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Lower section
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FutureBuilder<Map<DateTime, int>>(
                      future: fetchDailyUserGrowth(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                            child: Text('Error loading daily user growth.'),
                          );
                        }

                        final dailyData = snapshot.data!;
                        final spots = dailyData.entries
                            .map((e) => FlSpot(
                                  e.key.day.toDouble(),
                                  e.value.toDouble(),
                                ))
                            .toList();

                        return LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(DateFormat('MM/dd').format(
                                        DateTime.now().add(
                                            Duration(days: value.toInt()))));
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(value.toInt().toString());
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FutureBuilder<Map<int, int>>(
                      future: fetchMonthlyUserGrowth(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                            child: Text('Error loading monthly growth.'),
                          );
                        }

                        final monthlyData = snapshot.data!;
                        final bars = monthlyData.entries
                            .map(
                              (e) => BarChartGroupData(
                                x: e.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: e.value.toDouble(),
                                    color: Colors.blue,
                                    width: 20,
                                  ),
                                ],
                              ),
                            )
                            .toList();

                        return BarChart(
                          BarChartData(
                            barGroups: bars,
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const months = [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec'
                                    ];
                                    return Text(months[value.toInt() - 1]);
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(value.toInt().toString());
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardSection({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.blue, size: 30),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          child: CircularProgressIndicator(),
        ),
        SizedBox(height: 10),
        Text(
          'Loading...',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}
