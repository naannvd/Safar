import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safar/P_Routes/route_details.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({super.key, required this.routeName, required this.index});
  final String routeName;
  final int index;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        index % 2 == 0 ? Colors.white : const Color(0xFFA1CA73);
    final textColor = index % 2 == 0 ? const Color(0xFFA1CA73) : Colors.white;

    var colorVal = routeName == 'Red-Line'
        ? const Color(0xFFCC3636)
        : routeName == 'Orange-Line'
            ? const Color(0xFFE06236)
            : routeName == 'Green-Line'
                ? const Color(0xFFA1CA73)
                : const Color(0xFF3E7C98);
    return Hero(
      tag: 'routeCard$index',
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 7, top: 20),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteDetails(
                    routeName: routeName,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorVal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      routeName,
                      style: const TextStyle(
                          fontSize: 18, color: Color(0xFF042F40)),
                    ),
                    const Spacer(),
                    IconButton(
                      color: const Color(0xFF042F40),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios),
                    )
                  ],
                )
              ],
            ),
            // child: Text(
            //   routeName,
            //   style: const TextStyle(fontSize: 18),
            // ),
          ),
        ),
      ),
    );
  }
}
