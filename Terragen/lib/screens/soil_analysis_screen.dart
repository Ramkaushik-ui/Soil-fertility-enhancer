import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../repositories/soil_repository.dart';

class SoilAnalysisScreen extends StatefulWidget {
  final String langCode;
  final bool isExpertMode;
  const SoilAnalysisScreen({super.key, required this.langCode, required this.isExpertMode});

  @override
  State<SoilAnalysisScreen> createState() => _SoilAnalysisScreenState();
}

class _SoilAnalysisScreenState extends State<SoilAnalysisScreen> {
  final SoilRepository _soilRepo = SoilRepository();

  @override
  void initState() {
    super.initState();
    _soilRepo.addListener(_updateState);
  }

  @override
  void dispose() {
    _soilRepo.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.langCode;
    final soil = _soilRepo.currentReading;
    final history = _soilRepo.historicalReadings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get(lang, 'liveSensorReadings'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text('Node Alpha • Live Telemetry Stream', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _soilRepo.simulateSensorTelemetry(),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
              )
            ],
          ),
          const SizedBox(height: 16),

          // NPK Gauges Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Macro Nutrient Concentrations (NPK)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildNutrientRow('N', AppStrings.get(lang, 'nitrogen'), widget.isExpertMode ? '${soil.nitrogen.toInt()} ppm' : (soil.nitrogen > 150 ? 'Optimal' : 'Low'), (soil.nitrogen / 300.0).clamp(0.0, 1.0), Colors.green),
                  const SizedBox(height: 12),
                  _buildNutrientRow('P', AppStrings.get(lang, 'phosphorus'), widget.isExpertMode ? '${soil.phosphorus.toInt()} ppm' : (soil.phosphorus > 30 ? 'Optimal' : 'Low'), (soil.phosphorus / 80.0).clamp(0.0, 1.0), Colors.blue),
                  const SizedBox(height: 12),
                  _buildNutrientRow('K', AppStrings.get(lang, 'potassium'), widget.isExpertMode ? '${soil.potassium.toInt()} ppm' : (soil.potassium > 150 ? 'Optimal' : 'Low'), (soil.potassium / 350.0).clamp(0.0, 1.0), Colors.orange),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // pH & Moisture Grid
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(AppStrings.get(lang, 'soilPh'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (widget.isExpertMode) ...[
                          Text('${soil.ph}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                          const Text('Slightly Acidic (Ideal)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ] else
                          Text('Slightly Acidic', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Colors.teal.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(AppStrings.get(lang, 'moisture'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (widget.isExpertMode) ...[
                          Text('${soil.moisture.toInt()}%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal.shade900)),
                          const Text('Capacitive Probe', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ] else
                          Text('Optimal Moisture', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal.shade900)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Temperature
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.thermostat, color: Colors.deepOrange, size: 36),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.get(lang, 'temperature'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (widget.isExpertMode)
                        Text('${soil.temperature} °C', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange))
                      else
                        const Text('Warm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (widget.isExpertMode)
            // Historical Trends Visualizer
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.get(lang, 'historicalTrends'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Last 7 Days Nitrogen Telemetry Trend', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: history.take(7).toList().asMap().entries.map((entry) {
                          final idx = entry.key;
                          final item = entry.value;
                          final barFraction = (item.nitrogen / 300.0).clamp(0.1, 1.0);

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 18,
                                height: 90 * barFraction,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade700,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('D${idx + 1}', style: const TextStyle(fontSize: 10)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String symbol, String name, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(symbol, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                ),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: progress, color: color, backgroundColor: Colors.grey.shade200, minHeight: 6),
      ],
    );
  }
}
