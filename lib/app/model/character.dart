// ignore_for_file: public_member_api_docs, sort_constructors_first
class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json["id"],
      name: json["name"],
      status: json["status"],
      species: json["species"],
      image: json["image"],
    );
  }
}

class CharacterResponse {
  final List<Character> characters;
  final int totalPages;
  final int totalCount;
  final String? nextPage;
  final String? prevPage;

  CharacterResponse({
    required this.characters,
    required this.totalPages,
    required this.totalCount,
    this.nextPage,
    this.prevPage,
  });
}
