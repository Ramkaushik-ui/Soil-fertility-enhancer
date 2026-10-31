import '../models/models.dart';

class AiRecommendationEngine {
  static List<CropRecommendation> generateCropRecommendations(SoilReading soil) {
    final list = <CropRecommendation>[];

    final paddyMatch = (soil.moisture >= 50 && soil.ph >= 5.5 && soil.ph <= 7.5 && soil.nitrogen >= 150) ? 96 : 78;
    list.add(
      CropRecommendation(
        cropName: 'Paddy / Rice (ADT 45)',
        cropNameTamil: 'நெல் (ADT 45)',
        matchPercentage: paddyMatch,
        category: 'Cereal',
        expectedYieldTonsPerAcre: 2.8,
        season: 'Samba / Thaladi',
        rationale: 'Ideal soil pH (6.5-7.0) and high moisture retention suitability.',
        rationaleTamil: 'சிறந்த மண் pH மற்றும் அதிக ஈரப்பதம் தக்கவைக்கும் தன்மை.',
      ),
    );

    final maizeMatch = (soil.nitrogen >= 140 && soil.potassium >= 180) ? 92 : 72;
    list.add(
      CropRecommendation(
        cropName: 'Maize / Corn (CoHM 6)',
        cropNameTamil: 'மக்காச்சோளம் (CoHM 6)',
        matchPercentage: maizeMatch,
        category: 'Grain',
        expectedYieldTonsPerAcre: 3.5,
        season: 'Kharif / Rabi',
        rationale: 'Nitrogen (185 mg/kg) & Potassium levels closely match optimum maize intake.',
        rationaleTamil: 'நைட்ரஜன் மற்றும் பொட்டாசியம் அளவுகள் மக்காச்சோளத்திற்கு உகந்தது.',
      ),
    );

    final cottonMatch = (soil.ph >= 6.5 && soil.potassium >= 190 && soil.temperature >= 25) ? 88 : 65;
    list.add(
      CropRecommendation(
        cropName: 'Cotton (MCU 5)',
        cropNameTamil: 'பருத்தி (MCU 5)',
        matchPercentage: cottonMatch,
        category: 'Commercial',
        expectedYieldTonsPerAcre: 1.2,
        season: 'Winter / Summer',
        rationale: 'Soil temperature and well-drained loamy texture support deep taproot growth.',
        rationaleTamil: 'மண் வெப்பநிலை மற்றும் நல்ல வடிகால் வசதி பருத்திக்கு ஏற்றது.',
      ),
    );

    final gnutMatch = (soil.phosphorus >= 35 && soil.ph >= 6.0 && soil.ph <= 7.2) ? 85 : 60;
    list.add(
      CropRecommendation(
        cropName: 'Groundnut (VRI 2)',
        cropNameTamil: 'நிலக்கடலை (VRI 2)',
        matchPercentage: gnutMatch,
        category: 'Oilseed',
        expectedYieldTonsPerAcre: 1.1,
        season: 'Chithirai / Margazhi',
        rationale: 'Sufficient Phosphorus (42 mg/kg) fosters vigorous pod formation.',
        rationaleTamil: 'போதிய பாஸ்பரஸ் அளவு சிறந்த காய் உருவாக்கத்திற்கு உதவுகிறது.',
      ),
    );

    list.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
    return list;
  }

  static FertilizerAdvisory generateFertilizerAdvisory(SoilReading soil) {
    if (soil.nitrogen < 150) {
      return FertilizerAdvisory(
        cropName: 'Paddy / Maize',
        primaryDeficiency: 'Nitrogen Deficient',
        recommendedBlend: 'Urea (46% N) + Neem Cake',
        dosagePerAcre: '35 kg Urea + 100 kg Neem Cake per acre',
        applicationTiming: 'Split application: 50% basal, 25% tillering, 25% panicle initiation',
        organicAlternative: 'Vermicompost (2 tons/acre) + Azospirillum bio-fertilizer',
        organicAlternativeTamil: 'மண்புழு உரம் (2 டன்/ஏக்கர்) + அசோஸ்பைரில்லம் உயிர் உரம்',
      );
    } else if (soil.phosphorus < 30) {
      return FertilizerAdvisory(
        cropName: 'General Crops',
        primaryDeficiency: 'Phosphorus Deficient',
        recommendedBlend: 'Single Super Phosphate (SSP) 16% P2O5',
        dosagePerAcre: '75 kg SSP per acre',
        applicationTiming: 'Full basal dose during final ploughing',
        organicAlternative: 'Rock Phosphate + Phosphobacteria inoculation',
        organicAlternativeTamil: 'பாறை பாஸ்பேட் + பாஸ்போபேக்டீரியா உயிர் உரம்',
      );
    } else if (soil.potassium < 160) {
      return FertilizerAdvisory(
        cropName: 'Cotton / Groundnut',
        primaryDeficiency: 'Potassium Deficient',
        recommendedBlend: 'Muriate of Potash (MOP) 60% K2O',
        dosagePerAcre: '25 kg MOP per acre',
        applicationTiming: 'Basal application and flowering stage',
        organicAlternative: 'Wood Ash + Bio-Potash liquid spray',
        organicAlternativeTamil: 'மரச்சாம்பல் + பயோ-பொட்டாஷ் திரவ தெளிப்பு',
      );
    } else {
      return FertilizerAdvisory(
        cropName: 'All Major Crops',
        primaryDeficiency: 'Optimal Nutrient Balance',
        recommendedBlend: 'Customized NPK 17:17:17 Complex',
        dosagePerAcre: '20 kg/acre maintenance dose',
        applicationTiming: 'During crop establishment stage',
        organicAlternative: 'Panchagavya (3% spray) every 15 days',
        organicAlternativeTamil: 'பஞ்சகவ்யா (3% தெளிப்பு) 15 நாட்களுக்கு ஒருமுறை',
      );
    }
  }
}
