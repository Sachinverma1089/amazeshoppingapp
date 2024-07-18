import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

Future<String> getTemporaryDirectoryPath() async {
  if (kIsWeb) {
    // Implement a fallback or alternative logic for web
    throw UnsupportedError('Temporary directory not available on the web');
  } else {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
}
