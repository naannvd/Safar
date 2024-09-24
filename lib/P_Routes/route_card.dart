import 'package:flutter/material.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({super.key, required this.routeName});
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'routeCard',
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            routeName,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
