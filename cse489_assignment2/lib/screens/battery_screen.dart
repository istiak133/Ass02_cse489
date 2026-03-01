import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = -1;
  BatteryState _batteryState = BatteryState.unknown;
  late StreamSubscription<BatteryState> _batteryStateSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
      _getBatteryLevel(); // Refresh level when state changes
    });
  }

  Future<void> _getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    if (mounted) {
      setState(() {
        _batteryLevel = level;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _batteryStateSubscription.cancel();
    super.dispose();
  }

  String _getBatteryStateText() {
    switch (_batteryState) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Full';
      case BatteryState.connectedNotCharging:
        return 'Connected (Not Charging)';
      case BatteryState.unknown:
        return 'Unknown';
    }
  }

  IconData _getBatteryIcon() {
    if (_batteryState == BatteryState.charging) {
      return Icons.battery_charging_full;
    }
    if (_batteryLevel >= 90) return Icons.battery_full;
    if (_batteryLevel >= 60) return Icons.battery_5_bar;
    if (_batteryLevel >= 40) return Icons.battery_3_bar;
    if (_batteryLevel >= 20) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

  Color _getBatteryColor() {
    if (_batteryLevel >= 60) return Colors.green;
    if (_batteryLevel >= 20) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Battery Broadcast'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getBatteryIcon(),
                    size: 100,
                    color: _getBatteryColor(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$_batteryLevel%',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: _getBatteryColor(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Battery Level',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _batteryState == BatteryState.charging
                              ? Icons.power
                              : Icons.power_off,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status: ${_getBatteryStateText()}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Receiving system battery broadcast...',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
