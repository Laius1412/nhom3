import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final ImagePicker _picker = ImagePicker();

  // Đảm bảo cloudName và uploadPreset được cấu hình chính xác trên Cloudinary Console.
  final cloudinary = CloudinaryPublic(
    'dpphrzj9i', 
    'ml_default', 
    cache: false,
  );

  /// Hàm chọn ảnh từ Gallery và upload lên Cloudinary.
  /// Trả về URL ảnh nếu thành công, hoặc null nếu thất bại.
  Future<String?> uploadImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print("Người dùng đã không chọn ảnh.");
      return null;
    }

    try {
      // Nếu muốn, có thể chỉ định folder (ví dụ: "profile_pictures")
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          pickedFile.path,
          folder: "profile_pictures", // Thêm folder nếu cần
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      print("Upload thành công, URL: ${response.secureUrl}");
      return response.secureUrl;
    } catch (e) {
      print("Lỗi upload Cloudinary: $e");
      return null;
    }
  }
}
