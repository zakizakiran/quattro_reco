import 'dart:convert';

String decodeFromBase64(String encodedText) {
  String decodedText = utf8.decode(base64.decode(encodedText));
  return decodedText;
}

String encodeToBase64(String text) {
  String encodedText = base64.encode(utf8.encode(text));
  return encodedText;
}
