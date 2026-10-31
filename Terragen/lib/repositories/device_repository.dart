import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class DeviceRepository extends ChangeNotifier {
  static final DeviceRepository _instance = DeviceRepository._internal();
  factory DeviceRepository() => _instance;
  DeviceRepository._internal();

  List<IoTDevice> _devices = [
    IoTDevice(
      id: 'DEV-101',
      name: 'Soil Node Alpha (NPK & pH)',
      status: DeviceStatus.active,
      batteryLevel: 92,
      lastSyncTime: '2 mins ago',
      location: 'Block A - Paddy Field',
    ),
    IoTDevice(
      id: 'DEV-102',
      name: 'Soil Moisture & Temp Beta',
      status: DeviceStatus.active,
      batteryLevel: 84,
      lastSyncTime: '5 mins ago',
      location: 'Block B - Maize',
    ),
    IoTDevice(
      id: 'DEV-103',
      name: 'NPK Depth Node Gamma',
      status: DeviceStatus.offline,
      batteryLevel: 15,
      lastSyncTime: '3 hours ago',
      location: 'Block C - Cotton',
    ),
    IoTDevice(
      id: 'DEV-104',
      name: 'Microclimate Weather Station',
      status: DeviceStatus.active,
      batteryLevel: 98,
      lastSyncTime: '1 min ago',
      location: 'Farm Headquarters',
    ),
  ];

  List<IoTDevice> get devices => _devices;

  void addDevice(String name, String id, String location) {
    final rand = Random();
    final newDev = IoTDevice(
      id: id.isNotEmpty ? id : 'DEV-${rand.nextInt(900) + 100}',
      name: name,
      status: DeviceStatus.active,
      batteryLevel: 100,
      lastSyncTime: 'Just now',
      location: location.isNotEmpty ? location : 'General Field',
    );
    _devices.add(newDev);
    notifyListeners();
  }

  void toggleStatus(String id) {
    _devices = _devices.map((dev) {
      if (dev.id == id) {
        DeviceStatus nextStatus;
        switch (dev.status) {
          case DeviceStatus.active:
            nextStatus = DeviceStatus.offline;
            break;
          case DeviceStatus.offline:
            nextStatus = DeviceStatus.error;
            break;
          case DeviceStatus.error:
            nextStatus = DeviceStatus.active;
            break;
        }
        return dev.copyWith(status: nextStatus, lastSyncTime: 'Updated just now');
      }
      return dev;
    }).toList();
    notifyListeners();
  }
}
