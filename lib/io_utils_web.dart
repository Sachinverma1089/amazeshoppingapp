import 'dart:typed_data';
import 'dart:html';

Future<String> saveImageToFile(Uint8List data) async {
  final blob = Blob([data]);
  final url = Url.createObjectUrlFromBlob(blob);
  return url;
}
