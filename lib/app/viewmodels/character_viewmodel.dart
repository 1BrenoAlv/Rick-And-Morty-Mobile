import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/model/character.dart';
import 'package:rick_and_morty_mobile/app/service/caracter_service.dart';

class CharacterViewmodel extends ChangeNotifier {
  final CaracterService _service = CaracterService();

  List<Character> characters = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchCharacters() async {
    isLoading = true;
    notifyListeners();
    try {
      characters = await _service.getCharacters();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
