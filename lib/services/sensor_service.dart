import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  //Check if the phone is upside down (z value next to -9.8)
  bool isFaceDown(AccelerometerEvent event){
    return event.z < -8.0;
  }

  //Stream
  Stream<bool> get faceDownStream{
    return accelerometerEventStream().map((event) => isFaceDown(event));
  }
}