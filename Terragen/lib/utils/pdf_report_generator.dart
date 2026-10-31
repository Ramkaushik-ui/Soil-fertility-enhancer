import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../models/models.dart';
import '../repositories/ai_recommendation_engine.dart';
import '../repositories/auth_repository.dart';
import '../repositories/soil_repository.dart';

class PdfReportGenerator {
  static Future<void> generateAndOpenReport() async {
    final pdf = pw.Document();

    final user = AuthRepository().currentUser;
    final soil = SoilRepository().currentReading;
    final fertilizer = AiRecommendationEngine.generateFertilizerAdvisory(soil);
    final crops = AiRecommendationEngine.generateCropRecommendations(soil);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Terragen Soil & AI Advisory Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Date: ${DateTime.now().toLocal().toString().split(' ')[0]}', style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 20),

              // Farmer Details
              pw.Text('Farmer Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Text('Name: ${user?.fullName ?? "N/A"}'),
              pw.Text('Farm: ${user?.farmName ?? "N/A"}'),
              pw.Text('Location: ${user?.farmLocation ?? "N/A"}'),
              pw.Text('Soil Type: ${user?.soilType ?? "N/A"}'),
              pw.SizedBox(height: 20),

              // Soil Analysis
              pw.Text('Current Soil Health Analysis', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Text('Soil Health Index: ${soil.healthIndex}/100 (${soil.healthStatus})', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Bullet(text: 'Nitrogen (N): ${soil.nitrogen.toInt()} ppm'),
              pw.Bullet(text: 'Phosphorus (P): ${soil.phosphorus.toInt()} ppm'),
              pw.Bullet(text: 'Potassium (K): ${soil.potassium.toInt()} ppm'),
              pw.Bullet(text: 'pH Level: ${soil.ph}'),
              pw.Bullet(text: 'Moisture: ${soil.moisture.toInt()}%'),
              pw.SizedBox(height: 20),

              // AI Recommendations
              pw.Text('AI Fertilizer Advisory', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.Text('Deficiency: ${fertilizer.primaryDeficiency}', style: pw.TextStyle(color: PdfColors.red800)),
              pw.Text('Recommended Blend: ${fertilizer.recommendedBlend}'),
              pw.Text('Dosage: ${fertilizer.dosagePerAcre}'),
              pw.Text('Timing: ${fertilizer.applicationTiming}'),
              pw.Text('Organic Alternative: ${fertilizer.organicAlternative}', style: pw.TextStyle(color: PdfColors.green800)),
              pw.SizedBox(height: 20),

              pw.Text('Top Crop Recommendations', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              ...crops.take(3).map((crop) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('${crop.cropName} (${crop.matchPercentage}% match)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Expected Yield: ${crop.expectedYieldTonsPerAcre} Tons/Acre'),
                  pw.Text('Rationale: ${crop.rationale}'),
                  pw.SizedBox(height: 10),
                ]
              )).toList(),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/terragen_report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF
    await OpenFilex.open(file.path);
  }
}
