import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/models.dart';
import '../repositories/ai_recommendation_engine.dart';
import '../repositories/auth_repository.dart';
import '../repositories/device_repository.dart';
import '../repositories/soil_repository.dart';
import '../utils/pdf_report_generator.dart';

class DashboardScreen extends StatefulWidget {
  final String langCode;
  final bool isExpertMode;
  final Function(int) onNavigate;

  const DashboardScreen({
    super.key,
    required this.langCode,
    required this.isExpertMode,
    required this.onNavigate,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SoilRepository _soilRepo = SoilRepository();
  final DeviceRepository _deviceRepo = DeviceRepository();
  final AuthRepository _authRepo = AuthRepository();

  @override
  void initState() {
    super.initState();
    _soilRepo.addListener(_updateState);
    _deviceRepo.addListener(_updateState);
    _authRepo.addListener(_updateState);
  }

  @override
  void dispose() {
    _soilRepo.removeListener(_updateState);
    _deviceRepo.removeListener(_updateState);
    _authRepo.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.langCode;
    final user = _authRepo.currentUser;
    final soil = _soilRepo.currentReading;
    final devices = _deviceRepo.devices;

    final topCrop = AiRecommendationEngine.generateCropRecommendations(soil).first;
    final fertilizer = AiRecommendationEngine.generateFertilizerAdvisory(soil);

    final activeCount = devices.where((d) => d.status == DeviceStatus.active).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
          Card(
            color: Colors.green.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get(lang, 'welcomeFarmer', params: {'name': user?.fullName ?? 'Farmer'}),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user?.farmName ?? 'Farm'} • ${user?.farmLocation ?? 'Location'}',
                    style: TextStyle(fontSize: 13, color: Colors.green.shade800),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await PdfReportGenerator.generateAndOpenReport();
                    },
                    icon: const Icon(Icons.picture_as_pdf, size: 18),
                    label: Text(AppStrings.get(lang, 'generateReport')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Soil Health Index Card
          InkWell(
            onTap: () => widget.onNavigate(1),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.analytics, color: Colors.green.shade700),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.get(lang, 'soilHealthIndex'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.isExpertMode)
                              Text(
                                '${soil.healthIndex} / 100',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: soil.healthIndex >= 75 ? Colors.green.shade800 : Colors.orange.shade800,
                                ),
                              )
                            else
                              Text(
                                soil.healthStatus,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: soil.healthIndex >= 75 ? Colors.green.shade800 : Colors.orange.shade800,
                                ),
                              ),
                            Text(
                              AppStrings.get(lang, 'soilHealthStatus', params: {'status': soil.healthStatus}),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: soil.healthIndex >= 75 ? Colors.green.shade100 : Colors.orange.shade100,
                          ),
                          child: Center(
                            child: Text(
                              '${soil.healthIndex}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: soil.healthIndex >= 75 ? Colors.green.shade800 : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    if (widget.isExpertMode) ...[
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: soil.healthIndex / 100.0,
                        backgroundColor: Colors.grey.shade300,
                        color: soil.healthIndex >= 75 ? Colors.green.shade700 : Colors.orange.shade700,
                        minHeight: 8,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (widget.isExpertMode) ...[
            // Live NPK Grid (Expert Only)
            Text(
              AppStrings.get(lang, 'liveNpkSummary'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildMetricChip('N', '${soil.nitrogen.toInt()} ppm', 'Nitrogen')),
                const SizedBox(width: 6),
                Expanded(child: _buildMetricChip('P', '${soil.phosphorus.toInt()} ppm', 'Phosphorus')),
                const SizedBox(width: 6),
                Expanded(child: _buildMetricChip('K', '${soil.potassium.toInt()} ppm', 'Potassium')),
                const SizedBox(width: 6),
                Expanded(child: _buildMetricChip('pH', '${soil.ph}', 'pH Level')),
              ],
            ),
            const SizedBox(height: 16),
          ] else ...[
            // Simplified Nutrients Card (Normal Only)
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blue, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nutrient Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(soil.healthIndex >= 60 ? 'Levels are optimal' : 'Fertilizer needed', style: const TextStyle(color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // AI Quick Insight
          InkWell(
            onTap: () => widget.onNavigate(2),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.psychology, color: Colors.purple),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.get(lang, 'quickAiInsight'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Top Crop: ${topCrop.cropName} (${topCrop.matchPercentage}% match)',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800),
                    ),
                    const SizedBox(height: 4),
                    Text(topCrop.rationale, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(
                      'Recommended Fertilizer: ${fertilizer.recommendedBlend}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Connected Devices Overview
          InkWell(
            onTap: () => widget.onNavigate(3),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.memory, color: Colors.blue),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.get(lang, 'activeDevicesSummary'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('$activeCount of ${devices.length} Nodes Online', style: const TextStyle(fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String symbol, String value, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Text(symbol, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800, fontSize: 16)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(name, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }
}
