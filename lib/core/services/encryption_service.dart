import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EncryptionService {
  static const _keyName = 'savebabe_hive_key';

  final FlutterSecureStorage _storage;

  const EncryptionService(this._storage);

  /// Retourne la clé AES-256 existante ou en génère une nouvelle.
  Future<HiveCipher> getHiveCipher() async {
    String? encoded = await _storage.read(key: _keyName);
    if (encoded == null) {
      final key = Hive.generateSecureKey(); // 32 bytes aléatoires
      encoded = base64UrlEncode(key);
      await _storage.write(key: _keyName, value: encoded);
    }
    final keyBytes = base64Url.decode(encoded);
    if (keyBytes.length != 32) {
      throw StateError('La clé de chiffrement Hive doit contenir 32 octets.');
    }
    return HiveAesCipher(keyBytes);
  }
}
