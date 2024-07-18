import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Future<String> saveImageToFile(Uint8List data) async {
  final directory = await getTemporaryDirectory();
  final path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  final file = File(path);
  await file.writeAsBytes(data);
  return file.path;
}
