import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/model/character.dart';
import 'package:rick_and_morty_mobile/app/service/caracter_service.dart';

class CharacterViewmodel extends ChangeNotifier {
  final CaracterService _service = CaracterService();

  List<Character> characters = [];
  bool isLoading = false;
  String? error;
  int currentPage = 1;
  String currentSearchName = '';
  String currentStatus = '';
  String currentSpecies = '';
  String currentGender = '';

  Future<void> fetchCharacters() async {
    isLoading = true;
    notifyListeners();
    try {
      characters = await _service.getCharacters(
        page: currentPage,
        nameCaracter: currentSearchName,
        statusCaracter: currentStatus,
        speciesCaracter: currentSpecies,
        genderCaracter: currentGender,
      );
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void nextPage() {
    if (isLoading || currentPage >= 42) return;
    currentPage++;
    fetchCharacters();
    notifyListeners();
  }

  void previousPage() {
    if (isLoading || currentPage <= 1) return;
    currentPage--;
    fetchCharacters();
    notifyListeners();
  }
}
