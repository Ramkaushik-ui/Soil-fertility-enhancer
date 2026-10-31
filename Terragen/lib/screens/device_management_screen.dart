import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/models.dart';
import '../repositories/device_repository.dart';

class DeviceManagementScreen extends StatefulWidget {
  final String langCode;
  final bool isExpertMode;
  const DeviceManagementScreen({super.key, required this.langCode, required this.isExpertMode});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final DeviceRepository _deviceRepo = DeviceRepository();

  @override
  void initState() {
    super.initState();
    _deviceRepo.addListener(_updateState);
  }

  @override
  void dispose() {
    _deviceRepo.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  void _showAddDeviceDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.get(widget.langCode, 'registerDevice')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: AppStrings.get(widget.langCode, 'deviceName'), border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: AppStrings.get(widget.langCode, 'deviceId'), border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Field Location', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _deviceRepo.addDevice(nameController.text, idController.text, locationController.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Register'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.langCode;
    final devices = _deviceRepo.devices;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDeviceDialog,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get(lang, 'registeredDevices'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...devices.map((device) {
              Color statusColor;
              String statusText;
              switch (device.status) {
                case DeviceStatus.active:
                  statusColor = Colors.green;
                  statusText = AppStrings.get(lang, 'statusActive');
                  break;
                case DeviceStatus.offline:
                  statusColor = Colors.orange;
                  statusText = AppStrings.get(lang, 'statusOffline');
                  break;
                case DeviceStatus.error:
                  statusColor = Colors.red;
                  statusText = AppStrings.get(lang, 'statusError');
                  break;
              }

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.memory, color: Colors.blue, size: 32),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  if (widget.isExpertMode)
                                    Text('ID: ${device.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(device.location, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          if (widget.isExpertMode) ...[
                            Row(
                              children: [
                                const Icon(Icons.battery_full, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('Battery: ${device.batteryLevel}%', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.sync, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('Sync: ${device.lastSyncTime}', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ],
                      ),
                      if (widget.isExpertMode) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _deviceRepo.toggleStatus(device.id),
                            child: const Text('Simulate Node Status Toggle'),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
