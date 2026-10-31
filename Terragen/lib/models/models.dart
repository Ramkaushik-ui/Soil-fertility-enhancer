class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String farmName;
  final String farmLocation;
  final String soilType;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.farmName,
    required this.farmLocation,
    required this.soilType,
  });

  User copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? farmName,
    String? farmLocation,
    String? soilType,
  }) {
    return User(
      id: this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      farmName: farmName ?? this.farmName,
      farmLocation: farmLocation ?? this.farmLocation,
      soilType: soilType ?? this.soilType,
    );
  }
}

class SoilReading {
  final String id;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double ph;
  final double moisture;
  final double temperature;
  final int timestamp;

  SoilReading({
    this.id = 'sr_1',
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.ph,
    required this.moisture,
    required this.temperature,
    int? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  int get healthIndex {
    int score = 100;
    if (nitrogen < 120 || nitrogen > 300) score -= 15;
    if (phosphorus < 25 || phosphorus > 70) score -= 15;
    if (potassium < 130 || potassium > 320) score -= 15;
    if (ph < 5.8 || ph > 7.8) score -= 20;
    if (moisture < 35 || moisture > 80) score -= 20;
    if (temperature < 15 || temperature > 38) score -= 15;
    return score < 10 ? 10 : score;
  }

  String get healthStatus {
    if (healthIndex >= 80) return 'Excellent';
    if (healthIndex >= 60) return 'Good';
    if (healthIndex >= 40) return 'Fair';
    return 'Deficient';
  }
}

enum DeviceStatus { active, offline, error }

class IoTDevice {
  final String id;
  final String name;
  final DeviceStatus status;
  final int batteryLevel;
  final String lastSyncTime;
  final String location;

  IoTDevice({
    required this.id,
    required this.name,
    required this.status,
    required this.batteryLevel,
    required this.lastSyncTime,
    this.location = 'Block A',
  });

  IoTDevice copyWith({DeviceStatus? status, String? lastSyncTime}) {
    return IoTDevice(
      id: id,
      name: name,
      status: status ?? this.status,
      batteryLevel: batteryLevel,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      location: location,
    );
  }
}

class CropRecommendation {
  final String cropName;
  final String cropNameTamil;
  final int matchPercentage;
  final String category;
  final double expectedYieldTonsPerAcre;
  final String season;
  final String rationale;
  final String rationaleTamil;

  CropRecommendation({
    required this.cropName,
    required this.cropNameTamil,
    required this.matchPercentage,
    required this.category,
    required this.expectedYieldTonsPerAcre,
    required this.season,
    required this.rationale,
    required this.rationaleTamil,
  });
}

class FertilizerAdvisory {
  final String cropName;
  final String primaryDeficiency;
  final String recommendedBlend;
  final String dosagePerAcre;
  final String applicationTiming;
  final String organicAlternative;
  final String organicAlternativeTamil;

  FertilizerAdvisory({
    required this.cropName,
    required this.primaryDeficiency,
    required this.recommendedBlend,
    required this.dosagePerAcre,
    required this.applicationTiming,
    required this.organicAlternative,
    required this.organicAlternativeTamil,
  });
}

class WeatherInfo {
  final double temperature;
  final String condition;
  final int humidity;
  final int rainProbability;
  final double windSpeedKmH;
  final String forecastSummary;

  WeatherInfo({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.rainProbability,
    required this.windSpeedKmH,
    required this.forecastSummary,
  });
}

enum AlertSeverity { info, warning, critical }

class AlertItem {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final String timestamp;

  AlertItem({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
  });
}
