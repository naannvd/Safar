import 'dart:math';

//uses the Haversine formula to determine closest distance between two points on the earth

class DistanceCalculator {
  static double toRadians(double deg) => deg * pi / 180;

  static double haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // km
    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(lat1)) *
            cos(toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
}
