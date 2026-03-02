import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrService {
  final _picker = ImagePicker();
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<Map<String, dynamic>?> processReceipt(File image) async {
    final inputImage = InputImage.fromFile(image);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    double totalAmount = 0;

    // Simple rule-based extraction for "Total" price
    final lines = recognizedText.text.split('\n');
    for (var line in lines) {
      final cleanLine = line.toLowerCase();
      if (cleanLine.contains('total') ||
          cleanLine.contains('amount') ||
          cleanLine.contains('jumlah')) {
        // Extract numbers from line
        final regExp = RegExp(r'(\d+[\.,]\d+)|\d+');
        final matches = regExp.allMatches(line);
        if (matches.isNotEmpty) {
          final amountStr = matches.last.group(0)!.replaceAll(',', '');
          final amount = double.tryParse(amountStr);
          if (amount != null && amount > totalAmount) {
            totalAmount = amount;
          }
        }
      }
    }

    return {'total': totalAmount, 'text': recognizedText.text};
  }

  void dispose() {
    _textRecognizer.close();
  }
}
