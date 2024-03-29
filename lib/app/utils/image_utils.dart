import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  Future<XFile?> compress(File file, {Function(bool)? onLoading}) async {
    if (onLoading != null) onLoading(true);

    try {
      final dir = await getTemporaryDirectory();
      String fileName = file.path.split('/').last;

      final targetPath = dir.absolute.path + '/$fileName';

      XFile? result;
      // const int maxFileSize = 250000;
      int quality = 10;

      result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );

      final int compressedFileSize = await result?.length() ?? 0;

      debugPrint(file.lengthSync().toString());
      debugPrint(compressedFileSize.toString());

      if (onLoading != null) onLoading(false);

      return result;
    } catch (e) {
      debugPrint('Image Compress Error : $e');
      if (onLoading != null) onLoading(false);

      return null;
    }
  }
}
