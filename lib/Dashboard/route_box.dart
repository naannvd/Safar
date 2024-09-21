import 'package:flutter/material.dart';
import 'package:safar/P_Routes/routes_main.dart';

class RouteBox extends StatelessWidget {
  const RouteBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RoutesMain(),
          ));
        },
        child: Hero(
          tag: 'map.jpeg',
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFA1CA73), width: 4),
              image: const DecorationImage(
                image: AssetImage('assets/images/map.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Text(
              'Routes',
              style: Theme.of(context).textTheme.displayMedium,
            )),
          ),
        ),
      ),
    );
  }
}
