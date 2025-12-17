import 'package:flutter/material.dart';
import '../models/solar_reading.dart';
import '../services/mock_solar_service.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final MockSolarService _service = MockSolarService();
  late Stream<SolarReading> _readingStream;

  @override
  void initState() {
    super.initState();
    _readingStream = _service.getRealtimeStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SolarReading>(
      stream: _readingStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final reading = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Live Status',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildBatteryCard(context, reading),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive grid
                  int crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildInfoCard(
                        context,
                        'Voltage',
                        '${reading.voltage} V',
                        Icons.electric_bolt,
                        Colors.orange,
                      ),
                      _buildInfoCard(
                        context,
                        'Current',
                        '${reading.current} A',
                        Icons.waves,
                        Colors.blue,
                      ),
                      _buildInfoCard(
                        context,
                        'Power',
                        '${reading.power} W',
                        Icons.flash_on,
                        Colors.red,
                      ),
                      _buildInfoCard(
                        context,
                        'Temperature',
                        '${reading.temperature} °C',
                        Icons.thermostat,
                        Colors.green,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBatteryCard(BuildContext context, SolarReading reading) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Battery Level',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${reading.batteryLevel}%',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reading.batteryLevel > 20 ? 'Healthy' : 'Low Battery',
                    style: TextStyle(
                      color: reading.batteryLevel > 20 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: reading.batteryLevel / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getBatteryColor(reading.batteryLevel),
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.battery_charging_full,
                      size: 40,
                      color: _getBatteryColor(reading.batteryLevel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBatteryColor(double level) {
    if (level > 60) return Colors.green;
    if (level > 20) return Colors.orange;
    return Colors.red;
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
