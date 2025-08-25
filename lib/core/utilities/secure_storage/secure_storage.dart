import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kommuno/core/common/app_keys.dart';

part 'storage_enum.dart';

class SecureStorage {
  SecureStorage._();

  static final SecureStorage _ins = SecureStorage._();

  factory SecureStorage() {
    return _ins;
  }

  final _storage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true), iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));

  Future<bool> containsKey({required String key}) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> writeData({required String key, required Object? value}) async {
    try {
      await _storage.write(key: key, value: jsonEncode(value));
    } catch (e) {
      rethrow;
    }
  }

  Future<Object> readData({required String key}) async {
    try {
      final data = await _storage.read(key: key);
      if (data != null) {
        return jsonDecode(data);
      }
      throw AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.dataNotFound;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> readAllData() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteData({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllData() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      rethrow;
    }
  }
}
