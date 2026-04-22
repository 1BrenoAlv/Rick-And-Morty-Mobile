import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/model/character.dart';
import 'package:rick_and_morty_mobile/app/service/character_service.dart';

class CharacterViewmodel extends ChangeNotifier {
  final CharacterService _service = CharacterService();

  List<Character> characters = [];
  bool isLoading = false;
  String? error;
  int currentPage = 1;
  String? currentSearchName;
  String? currentStatus;
  String? currentSpecies;
  String? currentGender;
  int? pageTotal;
  String? nextBtn;
  String? prevBtn;

  Future<void> fetchCharacters() async {
    isLoading = true;
    error = null;
    notifyListeners();
    int attempt = 0;
    bool success = false;
    while (attempt < 3 && !success) {
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
        success = true;
        error = null;
      } catch (e) {
        debugPrint('Tentativa de carregar página: ${attempt + 1}');
        attempt++;
        if (e.toString().contains('429')) {
          await Future.delayed(const Duration(milliseconds: 2000));
        } else {
          error = 'Falha ao carregar. Verifique a internet.';
          break;
        }
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
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
