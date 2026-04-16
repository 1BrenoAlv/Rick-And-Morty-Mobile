import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/model/character.dart';
import 'package:rick_and_morty_mobile/app/service/character_service.dart';

class CharacterViewmodel extends ChangeNotifier {
  final CharacterService _service = CharacterService();

  List<Character> characters = [];
  bool isLoading = false;
  String? error;
  int currentPage = 1;
  int _lastPage = 1;
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
        _lastPage = currentPage;
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
