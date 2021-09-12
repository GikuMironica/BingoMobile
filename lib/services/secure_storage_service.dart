import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _flutterSecureStorage;

  SecureStorageService() : _flutterSecureStorage = FlutterSecureStorage();

  FlutterSecureStorage get fss=> _flutterSecureStorage;

  /// Read a value from a key.
  Future<String> read({@required String key}) async {
    return await _flutterSecureStorage.read(key: key);
  }

  /// Delete all keystore data
  Future<void> deleteAll() async {
    await _flutterSecureStorage.deleteAll();
  }

  /// Deletes a key from the secure keystore.
  Future<void> delete({@required String key}) async {
    await _flutterSecureStorage.delete(key: key);
  }

  // Writes a key:value into the secure keystore.
  Future<void> write({@required String key, @required String value}) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }
}
