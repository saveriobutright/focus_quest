import 'package:geolocator/geolocator.dart';

class LocationService {
  //University Coordinates
  static const double targetLat = 39.3660;
  static const double targetLon = 16.2251;
  static const double radiusInMeters = 300;

  //Check if the student is at the right place
  Future<bool> isAtUniversity() async{
    bool serviceEnabled;
    LocationPermission permission;

    //Check if GPS is on
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) return false;

    //Check permission
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) return false;
    }

    //Get current position
    Position position = await Geolocator.getCurrentPosition();

    //Distance between the student and the uni
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude, 
      position.longitude, 
      targetLat, 
      targetLon
      );

      return distanceInMeters <= radiusInMeters;
  }
}