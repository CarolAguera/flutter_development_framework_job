import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class MarvelAPI {
  static const publicKey = '63b931ef2ad255fdb755efbe5cd496eb';
  static const privateKey = 'cb3d14cd15009cb56598b0f7384e2c63ad864d28';

  static const baseUrl = 'https://gateway.marvel.com/v1/public';

  static String _generateHash(String timestamp) {
    var bytes = utf8.encode('$timestamp$privateKey$publicKey');
    var hash = md5.convert(bytes);
    return hash.toString();
  }

  static Future<dynamic> getCharacters({int offset = 0, int limit = 20}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = _generateHash(timestamp);

    final url = Uri.parse(
        '$baseUrl/characters?ts=$timestamp&apikey=$publicKey&hash=$hash&offset=$offset&limit=$limit');

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (data['code'] == 200) {
      final results = data['data']['results'];

      final filteredCharacters = results.where((character) {
        final imagePath = character['thumbnail']['path'];
        if (imagePath.contains('image_not_available')) {
          return false;
        } else {
          return true;
        }
      });

      return filteredCharacters.toList();
    } else {
      throw Exception('Erro ao carregar os dados: ${data['status']}');
    }
  }
}
