import 'dart:convert';
import 'package:crypto/crypto.dart';

class Nonce {
  String nonce;
  List<int> key;
  String? encoded;

  Nonce({required this.nonce, required this.key});

  Future encode(String message) async {
    List<int> messageBytes = utf8.encode(message);
    Hmac hmac = Hmac(sha512, key);
    Digest digest = hmac.convert(messageBytes);
    encoded = base64.encode(digest.bytes);
  }

  Map<String, String> header() {
    return {
      "X-Authorizationpolicy-Nonce": nonce,
      "X-Authorizationpolicy-Key": encoded ?? "",
      "X-Authorizationpolicy-Version": "v2",
    };
  }
}
