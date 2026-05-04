import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_mobile/app/model/character.dart';
import 'package:rick_and_morty_mobile/app/service/app_exceptions.dart';

class CharacterService {
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  /// Timeout padrão para requisições HTTP.
  static const Duration _requestTimeout = Duration(seconds: 15);

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

    final uri = Uri.parse('$_baseUrl/character').replace(
      queryParameters: queryParams,
    );

    final http.Response response;

    try {
      response = await http.get(uri).timeout(_requestTimeout);
    } on SocketException {
      throw const NoInternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on HttpException {
      throw const NoInternetException(
        'Falha na comunicação com o servidor.',
      );
    } catch (_) {
      throw const NoInternetException();
    }

    return _handleResponse(response);
  }

  /// Processa a resposta HTTP e retorna [CharacterResponse] ou lança
  /// a exceção tipada correspondente ao código de status.
  CharacterResponse _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return _parseSuccess(response.body);
      case 404:
        throw const NotFoundException();
      case 429:
        throw const TooManyRequestsException();
      default:
        if (response.statusCode >= 500) {
          throw ServerException(
            'Serviço temporariamente indisponível. Tente mais tarde.',
            response.statusCode,
          );
        }
        throw UnknownApiException(
          'Erro inesperado (código ${response.statusCode}).',
          response.statusCode,
        );
    }
  }

  /// Faz o parse do JSON de sucesso (status 200).
  CharacterResponse _parseSuccess(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      final info = data['info'] as Map<String, dynamic>;
      final List results = data['results'] as List;

      return CharacterResponse(
        characters: results.map((e) => Character.fromJson(e)).toList(),
        totalPages: info['pages'] as int,
        totalCount: info['count'] as int,
        nextPage: info['next'] as String?,
        prevPage: info['prev'] as String?,
      );
    } catch (e) {
      throw UnknownApiException(
        'Erro ao processar os dados recebidos.',
      );
    }
  }
}
