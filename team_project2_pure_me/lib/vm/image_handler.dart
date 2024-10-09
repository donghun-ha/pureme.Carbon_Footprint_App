import 'dart:io';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

class ImageHandler extends GetxController {
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  File? imgFile;

  getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      imageFile = XFile(pickedFile.path);
      imgFile = File(imageFile!.path);
      update();
    }
  }
}
