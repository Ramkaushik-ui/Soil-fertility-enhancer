import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class SoilRepository extends ChangeNotifier {
  static final SoilRepository _instance = SoilRepository._internal();
  factory SoilRepository() => _instance;
  SoilRepository._internal() {
    _historicalReadings = _generateHistoricalReadings();
  }

  SoilReading _currentReading = SoilReading(
    nitrogen: 185.0,
    phosphorus: 42.0,
    potassium: 210.0,
    ph: 6.8,
    moisture: 55.0,
    temperature: 27.5,
  );

  List<SoilReading> _historicalReadings = [];

  SoilReading get currentReading => _currentReading;
  List<SoilReading> get historicalReadings => _historicalReadings;

  void simulateSensorTelemetry() {
    final rand = Random();
    final n = 160.0 + rand.nextInt(60);
    final p = 30.0 + rand.nextInt(25);
    final k = 180.0 + rand.nextInt(60);
    final phVal = 6.2 + rand.nextInt(11) / 10.0;
    final m = 45.0 + rand.nextInt(23);
    final t = 24.0 + rand.nextInt(7);

    _currentReading = SoilReading(
      nitrogen: n,
      phosphorus: p,
      potassium: k,
      ph: phVal,
      moisture: m,
      temperature: t,
    );

    if (_historicalReadings.length >= 7) {
      _historicalReadings.removeAt(0);
    }
    _historicalReadings.add(_currentReading);

    notifyListeners();
  }

  List<SoilReading> _generateHistoricalReadings() {
    final rand = Random();
    final list = <SoilReading>[];
    for (int i = 6; i >= 0; i--) {
      list.add(
        SoilReading(
          id: 'hist_$i',
          nitrogen: 170.0 + rand.nextInt(40) - 20,
          phosphorus: 40.0 + rand.nextInt(20) - 10,
          potassium: 200.0 + rand.nextInt(40) - 20,
          ph: 6.5 + (rand.nextInt(9) - 4) / 10.0,
          moisture: 50.0 + rand.nextInt(30) - 15,
          temperature: 26.0 + rand.nextInt(7) - 3,
          timestamp: DateTime.now().millisecondsSinceEpoch - i * 86400000,
        ),
      );
    }
    return list;
  }
}
