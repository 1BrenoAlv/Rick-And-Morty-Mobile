import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/model/character.dart';
import 'package:rick_and_morty_mobile/app/service/app_exceptions.dart';
import 'package:rick_and_morty_mobile/app/service/character_service.dart';

/// Tipos de erro para a UI exibir ícones e mensagens adequadas.
enum ErrorType {
  noInternet,
  timeout,
  notFound,
  tooManyRequests,
  server,
  unknown,
}

class CharacterViewmodel extends ChangeNotifier {
  final CharacterService _service = CharacterService();

  List<Character> characters = [];
  bool isLoading = false;
  bool isFilterLoading = false;
  String? error;
  ErrorType? errorType;
  int currentPage = 1;
  String? currentSearchName;
  String? currentStatus;
  String? currentSpecies;
  String? currentGender;
  int? pageTotal;
  String? nextBtn;
  String? prevBtn;

  /// Número máximo de tentativas para erro 429 (rate limit).
  static const int _maxRetries = 3;

  Future<void> fetchCharacters() async {
    isLoading = true;
    error = null;
    errorType = null;
    notifyListeners();

    int attempt = 0;

    while (attempt < _maxRetries) {
      try {
        final response = await _service.getCharacters(
          page: currentPage,
          nameCharacter: currentSearchName,
          statusCharacter: currentStatus,
          speciesCharacter: currentSpecies,
          genderCharacter: currentGender,
        );

        characters = response.characters;
        nextBtn = response.nextPage;
        prevBtn = response.prevPage;
        pageTotal = response.totalPages;
        isFilterLoading = true;
        error = null;
        errorType = null;
        break; // Sucesso — sai do loop.

      } on TooManyRequestsException {
        // Rate limit — tenta novamente após delay.
        attempt++;
        debugPrint('Rate limit atingido. Tentativa $attempt de $_maxRetries.');
        if (attempt >= _maxRetries) {
          _setError(
            'Muitas requisições. Aguarde um momento e tente novamente.',
            ErrorType.tooManyRequests,
          );
        } else {
          await Future.delayed(const Duration(milliseconds: 2000));
        }
      } on NotFoundException {
        // 404 — nenhum resultado para os filtros atuais.
        characters = [];
        nextBtn = null;
        prevBtn = null;
        pageTotal = 0;
        isFilterLoading = true;
        error = null;
        errorType = ErrorType.notFound;
        break;
      } on NoInternetException catch (e) {
        _setError(e.message, ErrorType.noInternet);
        break;
      } on RequestTimeoutException catch (e) {
        _setError(e.message, ErrorType.timeout);
        break;
      } on ServerException catch (e) {
        _setError(e.message, ErrorType.server);
        break;
      } on AppException catch (e) {
        _setError(e.message, ErrorType.unknown);
        break;
      } catch (e) {
        _setError(
          'Ocorreu um erro inesperado. Tente novamente.',
          ErrorType.unknown,
        );
        debugPrint('Erro não tratado: $e');
        break;
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void _setError(String message, ErrorType type) {
    error = message;
    errorType = type;
  }

  void filterAplly({
    required String search,
    String? status,
    String? species,
    String? gender,
  }) {
    currentSearchName = search.isEmpty ? null : search;
    currentStatus = status == 'Todos os status' ? null : status;
    currentSpecies = species == 'Todas as espécies' ? null : species;
    currentGender = gender == 'Todos os gêneros' ? null : gender;
    currentPage = 1;
    fetchCharacters();
  }

  void clearFilter() {
    currentSearchName = null;
    currentStatus = null;
    currentSpecies = null;
    currentGender = null;

    currentPage = 1;

    fetchCharacters();
  }

  void nextPage() {
    if (isLoading || nextBtn == null) return;
    currentPage++;
    fetchCharacters();
  }

  void previousPage() {
    if (isLoading || prevBtn == null) return;
    currentPage--;
    fetchCharacters();
  }
}
