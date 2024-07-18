import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Future<Map<String, dynamic>> pickImages() async {
  List<io.File> files = [];
  List<Uint8List> webFiles = [];

  try {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        if (kIsWeb) {
          // Platform is web, use bytes
          webFiles.add(file.bytes!);
        } else {
          // Platform is not web, use io.File
          files.add(io.File(file.path!));
        }
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return {
    'files': files,
    'webFiles': webFiles,
  };
}
