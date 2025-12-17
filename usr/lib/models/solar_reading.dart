class SolarReading {
  final DateTime timestamp;
  final double voltage; // Volts
  final double current; // Amps
  final double power;   // Watts
  final double batteryLevel; // Percentage 0-100
  final double temperature; // Celsius

  SolarReading({
    required this.timestamp,
    required this.voltage,
    required this.current,
    required this.power,
    required this.batteryLevel,
    required this.temperature,
  });
}
