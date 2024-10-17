import 'dart:io';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

class ImageHandler extends GetxController {
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  File? imgFile;

  /// 이미지를 갤러리에서 가져오는 함수
  /// imageSource는 Camera와 Gallery가능
  getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      imageFile = XFile(pickedFile.path);
      imgFile = File(imageFile!.path);
      update();
    }
  }
}
