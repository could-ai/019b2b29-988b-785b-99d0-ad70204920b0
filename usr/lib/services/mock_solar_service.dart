import 'dart:async';
import 'dart:math';
import '../models/solar_reading.dart';

class MockSolarService {
  final _random = Random();

  // Simulate a stream of real-time data from ESP32
  Stream<SolarReading> getRealtimeStream() {
    return Stream.periodic(const Duration(seconds: 2), (_) {
      return _generateRandomReading();
    });
  }

  // Simulate fetching stored historical data
  Future<List<SolarReading>> getHistoryData(String period) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    List<SolarReading> history = [];
    DateTime now = DateTime.now();
    int points = period == 'Day' ? 24 : 7; // 24 hours or 7 days
    
    for (int i = 0; i < points; i++) {
      DateTime time = period == 'Day' 
          ? now.subtract(Duration(hours: points - i))
          : now.subtract(Duration(days: points - i));
      
      history.add(_generateRandomReading(time: time));
    }
    return history;
  }

  SolarReading _generateRandomReading({DateTime? time}) {
    double voltage = 11.5 + _random.nextDouble() * 2.5; // 11.5V - 14.0V
    double current = _random.nextDouble() * 5.0; // 0A - 5A
    double power = voltage * current;
    double battery = ((voltage - 11.5) / 2.5) * 100;
    double temp = 20 + _random.nextDouble() * 15; // 20C - 35C

    return SolarReading(
      timestamp: time ?? DateTime.now(),
      voltage: double.parse(voltage.toStringAsFixed(2)),
      current: double.parse(current.toStringAsFixed(2)),
      power: double.parse(power.toStringAsFixed(2)),
      batteryLevel: double.parse(battery.clamp(0, 100).toStringAsFixed(1)),
      temperature: double.parse(temp.toStringAsFixed(1)),
    );
  }
}
