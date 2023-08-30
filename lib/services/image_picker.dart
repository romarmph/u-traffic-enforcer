import 'dart:io';

import '../config/utils/exports.dart';

class ImagePickerService {
  ImagePickerService._();

  static final ImagePickerService instance = ImagePickerService._();

  final ImagePicker _picker = ImagePicker();

  ImageSource get defaultImageSource => ImageSource.camera;

  Future<XFile?> pickImage() async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear,
      );

      return image;
    } on Exception {
      rethrow;
    }
  }

  Future<CroppedFile?> cropImage(XFile image) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true,
          ),
        ],
      );

      return croppedFile;
    } on Exception {
      rethrow;
    }
  }

  File rename(XFile file, String name) {
    String path = file.path;
    int lastSeparater = path.lastIndexOf(Platform.pathSeparator);
    String newPath = "${path.substring(0, lastSeparater + 1)}$name.jpg";

    return File(path).renameSync(newPath);
  }
}
