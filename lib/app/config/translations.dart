class AppTranslations {
  AppTranslations._();

  static const Map<String, String> _status = {
    'alive': 'Vivo',
    'dead': 'Morto',
    'unknown': 'Desconhecido',
  };

  static String status(String value) =>
      _status[value.toLowerCase()] ?? value;

  static const Map<String, String> _species = {
    'human': 'Humano',
    'alien': 'Alienígena',
    'humanoid': 'Humanóide',
    'poopybutthole': 'Poopybutthole',
    'mythological creature': 'Criatura Mitológica',
    'mythological': 'Mitológico',
    'animal': 'Animal',
    'robot': 'Robô',
    'cronenberg': 'Cronenberg',
    'disease': 'Doença',
    'planet': 'Planeta',
    'unknown': 'Desconhecida',
  };

  static String species(String value) =>
      _species[value.toLowerCase()] ?? value;

  static const Map<String, String> _gender = {
    'male': 'Masculino',
    'female': 'Feminino',
    'genderless': 'Sem gênero',
    'unknown': 'Desconhecido',
  };

  static String gender(String value) =>
      _gender[value.toLowerCase()] ?? value;

  static const Map<String, String?> statusFilters = {
    'Todos os status': null,
    'Vivo': 'Alive',
    'Morto': 'Dead',
    'Desconhecido': 'Unknown',
  };

  static const Map<String, String?> speciesFilters = {
    'Todas as espécies': null,
    'Humano': 'Human',
    'Alienígena': 'Alien',
    'Humanóide': 'Humanoid',
    'Robô': 'Robot',
    'Criatura Mitológica': 'Mythological Creature',
    'Animal': 'Animal',
    'Cronenberg': 'Cronenberg',
    'Doença': 'Disease',
    'Planeta': 'Planet',
    'Poopybutthole': 'Poopybutthole',
    'Desconhecida': 'Unknown',
  };

  static const Map<String, String?> genderFilters = {
    'Todos os gêneros': null,
    'Masculino': 'Male',
    'Feminino': 'Female',
    'Sem gênero': 'Genderless',
    'Desconhecido': 'Unknown',
  };
}
