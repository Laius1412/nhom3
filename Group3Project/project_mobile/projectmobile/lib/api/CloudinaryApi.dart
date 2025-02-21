import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

class CloudinaryService {
  static const String cloudName = "dpphrzj9i";
  static const String apiKey = "651239291262786";
  static const String uploadPreset = "ml_default"; // Ensure this is set correctly in Cloudinary

  Future<String?> uploadImage(File imageFile) async {
    try {
      final mimeType = lookupMimeType(imageFile.path);
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      var request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..fields['api_key'] = apiKey
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url']; // Return the uploaded image URL
      } else {
        print("Cloudinary upload failed: ${jsonResponse['error']['message']}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
