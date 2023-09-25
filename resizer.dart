import 'dart:io';
import 'package:image/image.dart' as img;


void main() {
  final inputFolder = Directory('/Users/ryofukahori/Desktop/test1');
  final outputFolder = Directory('/Users/ryofukahori/Desktop/test2');

  if (!outputFolder.existsSync()) {
    outputFolder.createSync(recursive: true);
  }

  inputFolder.listSync().forEach((file) {
    if (file is File && _isSupportedImage(file.path)) {
      final inputFile = file as File;
      final outputFile = File('${outputFolder.path}/${inputFile.path.split('/').last}');

      _resizeImage(inputFile.path, outputFile.path);
    }
  });
}

bool _isSupportedImage(String filePath) {
  final supportedExtensions = ['.png', '.jpg', '.jpeg'];
  final extension = filePath.toLowerCase();

  return supportedExtensions.any((ext) => extension.endsWith(ext));
}

void _resizeImage(String inputPath, String outputPath) {
  final image = img.decodeImage(File(inputPath).readAsBytesSync());

  if (image != null) {
    final width = image.width;
    final newHeight = (width * 3 / 4).toInt();

    final resizedImage = img.copyResize(image, width: width, height: newHeight);
    File(outputPath).writeAsBytesSync(img.encodeJpg(resizedImage));
  } else {
    print('Error decoding image: $inputPath');
  }
}
