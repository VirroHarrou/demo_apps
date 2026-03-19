import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class VaultService {
  final _storage = const FlutterSecureStorage();

  final List<String> _wordList = [
    'Apple',
    'Battery',
    'Cloud',
    'God',
    'Driver',
    'Eagle',
    'Rocket',
    'Forest',
    'Grapes',
    'Hammer',
    'Ice',
    'Iron',
    'Joker',
    'Kite',
    'Lemon',
    'Mountain',
    'Night',
  ];

  String generateMemorablePassword({int wordsCount = 4}) {
    final random = Random.secure();
    List<String> selectedWords = List.generate(
      wordsCount,
      (_) => _wordList[random.nextInt(_wordList.length)],
    );
    return selectedWords.join('-');
  }

  Future<void> savePassword(String service, String password) async {
    String? rawData = await _storage.read(key: 'vault_data');
    List<dynamic> list = rawData != null ? jsonDecode(rawData) : [];

    list.add({'serviceName': service, 'password': password});
    await _storage.write(key: 'vault_data', value: jsonEncode(list));
  }

  Future<List<dynamic>> getAllPasswords() async {
    String? rawData = await _storage.read(key: 'vault_data');
    return rawData != null ? jsonDecode(rawData) : [];
  }
}
