import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_mobile/app/model/character.dart';

class CaracterService {
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> getCharacters({
    int page = 1,
    String? nameCaracter,
    String? statusCaracter,
    String? speciesCaracter,
    String? genderCaracter,
  }) async {
    final Map<String, String> queryParams = {'page': page.toString()};
    if (nameCaracter != null && nameCaracter.trim().isNotEmpty) {
      queryParams['name'] = nameCaracter;
    }
    if (statusCaracter != null && statusCaracter.trim().isNotEmpty) {
      queryParams['status'] = statusCaracter;
    }
    if (speciesCaracter != null && speciesCaracter.trim().isNotEmpty) {
      queryParams['species'] = speciesCaracter;
    }
    if (genderCaracter != null && genderCaracter.trim().isNotEmpty) {
      queryParams['gender'] = genderCaracter;
    }
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/character').replace(queryParameters: queryParams),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];
        return results.map((e) => Character.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
          'Erro ao buscar personagens. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
