import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_mobile/app/model/character.dart';

class CharacterService {
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<CharacterResponse> getCharacters({
    int page = 1,
    String? nameCharacter,
    String? statusCharacter,
    String? speciesCharacter,
    String? genderCharacter,
  }) async {
    final Map<String, String> queryParams = {'page': page.toString()};
    if (nameCharacter != null && nameCharacter.trim().isNotEmpty) {
      queryParams['name'] = nameCharacter;
    }
    if (statusCharacter != null && statusCharacter.trim().isNotEmpty) {
      queryParams['status'] = statusCharacter;
    }
    if (speciesCharacter != null && speciesCharacter.trim().isNotEmpty) {
      queryParams['species'] = speciesCharacter;
    }
    if (genderCharacter != null && genderCharacter.trim().isNotEmpty) {
      queryParams['gender'] = genderCharacter;
    }
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/character').replace(queryParameters: queryParams),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final int totalPages = data['info']['pages'];
        final int totalCount = data['info']['count'];
        final String? nextPage = data['info']['next'];
        final String? prevPage = data['info']['prev'];
        final List results = data['results'];
        final characterList = results
            .map((e) => Character.fromJson(e))
            .toList();
        return CharacterResponse(
          characters: characterList,
          totalPages: totalPages,
          totalCount: totalCount,
          nextPage: nextPage,
          prevPage: prevPage,
        );
      } else if (response.statusCode == 404) {
        return CharacterResponse(
          characters: [],
          totalPages: 0,
          totalCount: 0,
          nextPage: null,
          prevPage: null,
        );
      } else {
        throw Exception('Erro na API. Código: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Erro na API')) {
        rethrow;
      }
      throw Exception('Erro de conexão: $e');
    }
  }
}
