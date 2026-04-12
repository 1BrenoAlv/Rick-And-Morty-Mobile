import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_mobile/app/model/character.dart';

class CaracterService {
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> getCharacters() async {
    final response = await http.get(Uri.parse('$_baseUrl/character'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((e) => Character.fromJson(e)).toList();
    }
    throw Exception('Erro ao buscar personagens');
  }
}
