import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final ImagePicker _picker = ImagePicker();
  final cloudinary = CloudinaryPublic('dpphrzj9i', 'your-upload-preset', cache: false);

  Future<String?> uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: "profile_pictures"),
      );

      return response.secureUrl; // Trả về URL ảnh sau khi upload
    } catch (e) {
      print("Lỗi upload ảnh: $e");
      return null;
    }
  }
}
