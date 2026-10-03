import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:save_babe/core/services/encryption_service.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockFlutterSecureStorage storage;
  const keyName = 'savebabe_hive_key';

  setUp(() {
    storage = _MockFlutterSecureStorage();
  });

  test('creates and persists a 32-byte key when none exists', () async {
    String? savedValue;
    when(() => storage.read(key: keyName)).thenAnswer((_) async => null);
    when(() => storage.write(key: keyName, value: any(named: 'value')))
        .thenAnswer((invocation) async {
      savedValue = invocation.namedArguments[#value] as String;
    });

    final cipher = await EncryptionService(storage).getHiveCipher();

    expect(cipher, isA<HiveAesCipher>());
    expect(base64Url.decode(savedValue!), hasLength(32));
    verify(() => storage.write(key: keyName, value: any(named: 'value')))
        .called(1);
  });

  test('reuses a previously stored 32-byte key', () async {
    final encodedKey = base64UrlEncode(List<int>.filled(32, 7));
    when(() => storage.read(key: keyName)).thenAnswer((_) async => encodedKey);

    final cipher = await EncryptionService(storage).getHiveCipher();

    expect(cipher, isA<HiveAesCipher>());
    verifyNever(
      () => storage.write(key: keyName, value: any(named: 'value')),
    );
  });

  test('rejects a stored key with an invalid length', () async {
    final encodedKey = base64UrlEncode(List<int>.filled(16, 7));
    when(() => storage.read(key: keyName)).thenAnswer((_) async => encodedKey);

    await expectLater(
      EncryptionService(storage).getHiveCipher(),
      throwsStateError,
    );
    verifyNever(
      () => storage.write(key: keyName, value: any(named: 'value')),
    );
  });
}
