import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart' as path;
import 'package:image/image.dart' as img;

class SignatureServices {
  Future<File> saveImage(ui.Image image) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    Directory tempDir = await path.getTemporaryDirectory();
    String tempPath = tempDir.path;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    File file = File('$tempPath/$fileName.png');

    img.Image? decodedImage = img.decodeImage(pngBytes);
    file.writeAsBytesSync(img.encodePng(decodedImage!));

    return file;
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}
