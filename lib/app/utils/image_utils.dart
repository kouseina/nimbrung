import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  Future<XFile?> compress(File file) async {
    final dir = await getTemporaryDirectory();
    String fileName = file.path.split('/').last;

    final targetPath = dir.absolute.path + '/$fileName';

    XFile? result;
    const int maxFileSize = 250000;
    int quality = 10;

    result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );

    final int compressedFileSize = await result?.length() ?? 0;

    print(file.lengthSync());
    print(compressedFileSize);

    return result;
  }
}
