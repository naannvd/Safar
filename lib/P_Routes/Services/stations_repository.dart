import 'package:cloud_firestore/cloud_firestore.dart';

class StationsRepository {
  final FirebaseFirestore firestore;

  StationsRepository({required this.firestore});

  Future<List<Map<String, dynamic>>> fetchStations() async {
    final snapshot = await firestore.collection('stations').get();
    return snapshot.docs
        .map((doc) => {
              'name': doc['station_name'],
              'latitude': doc['latitude'],
              'longitude': doc['longitude'],
            })
        .toList();
  }
}
