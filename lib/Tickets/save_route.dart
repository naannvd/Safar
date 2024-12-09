// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaveRoute {
  Future<void> saveRoute(
      {required String userId,
      required String fromStation,
      required String toStation,
      required String routeName}) async {
    try {
      await FirebaseFirestore.instance.collection('saved_routes').add({
        'user_id': userId,
        'fromStation': fromStation,
        'toStation': toStation,
        'route_name': routeName,
      });
      print('route saved');
    } catch (e) {
      throw Exception("Error saving route: $e");
    }
  }
}
