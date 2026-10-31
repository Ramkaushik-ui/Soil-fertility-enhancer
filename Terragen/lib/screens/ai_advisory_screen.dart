import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../repositories/ai_recommendation_engine.dart';
import '../repositories/soil_repository.dart';

class AiAdvisoryScreen extends StatefulWidget {
  final String langCode;
  const AiAdvisoryScreen({super.key, required this.langCode});

  @override
  State<AiAdvisoryScreen> createState() => _AiAdvisoryScreenState();
}

class _AiAdvisoryScreenState extends State<AiAdvisoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SoilRepository _soilRepo = SoilRepository();

  // Feedback form state
  final _cropController = TextEditingController(text: 'Paddy / Rice');
  final _expectedYieldController = TextEditingController(text: '2.8');
  final _actualYieldController = TextEditingController(text: '2.9');
  final _fertilizerController = TextEditingController(text: 'Urea 35kg + Neem Cake 100kg');
  int _rating = 5;
  bool _feedbackSubmitted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cropController.dispose();
    _expectedYieldController.dispose();
    _actualYieldController.dispose();
    _fertilizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.langCode;
    final soil = _soilRepo.currentReading;

    final crops = AiRecommendationEngine.generateCropRecommendations(soil);
    final fertilizer = AiRecommendationEngine.generateFertilizerAdvisory(soil);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.green.shade800,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green.shade800,
          tabs: [
            Tab(text: AppStrings.get(lang, 'aiCropRecommendations')),
            Tab(text: AppStrings.get(lang, 'fertilizerAdvisory')),
            Tab(text: AppStrings.get(lang, 'yieldFeedback')),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: AI Crops
              ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: crops.length,
                itemBuilder: (context, index) {
                  final crop = crops[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      crop.cropName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Text(
                                      'Category: ${crop.category} • Season: ${crop.season}',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: crop.matchPercentage >= 85 ? Colors.green.shade100 : Colors.orange.shade100,
                                child: Text(
                                  '${crop.matchPercentage}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: crop.matchPercentage >= 85 ? Colors.green.shade800 : Colors.orange.shade800,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Expected Yield: ${crop.expectedYieldTonsPerAcre} Tons / Acre',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(crop.rationale, style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Tab 2: Fertilizer Advisory
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Soil Deficiency Diagnosis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                fertilizer.primaryDeficiency,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(AppStrings.get(lang, 'recommendedFertilizer'), style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(fertilizer.recommendedBlend, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                            const SizedBox(height: 8),
                            Text('Dosage: ${fertilizer.dosagePerAcre}'),
                            const SizedBox(height: 8),
                            Text('Timing: ${fertilizer.applicationTiming}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.eco, color: Colors.green, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Organic Alternative', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                  const SizedBox(height: 4),
                                  Text(fertilizer.organicAlternative, style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Tab 3: Yield Feedback
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Report Harvest & Yield Feedback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('Your feedback tunes future AI predictions for your farm.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 16),

                        TextField(
                          controller: _cropController,
                          decoration: const InputDecoration(labelText: 'Crop Name', border: OutlinedInputBorder()),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _expectedYieldController,
                                decoration: const InputDecoration(labelText: 'Expected Yield', border: OutlinedInputBorder()),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _actualYieldController,
                                decoration: const InputDecoration(labelText: 'Actual Yield', border: OutlinedInputBorder()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: _fertilizerController,
                          decoration: const InputDecoration(labelText: 'Fertilizer Used', border: OutlinedInputBorder()),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Text('Rating: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              children: List.generate(5, (idx) {
                                return IconButton(
                                  icon: Icon(
                                    idx < _rating ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () => setState(() => _rating = idx + 1),
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                _feedbackSubmitted = true;
                              });
                            },
                            child: Text(AppStrings.get(lang, 'submitFeedback')),
                          ),
                        ),

                        if (_feedbackSubmitted) ...[
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Feedback recorded successfully!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
