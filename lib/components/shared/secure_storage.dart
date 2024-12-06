import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Singleton instance
  static final SecureStorage _instance = SecureStorage._internal();

  // Private constructor
  SecureStorage._internal();

  // Access the singleton instance
  factory SecureStorage() {
    return _instance;
  }

  final FlutterSecureStorage storage = const FlutterSecureStorage();
}
