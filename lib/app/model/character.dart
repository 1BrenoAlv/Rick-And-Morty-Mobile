class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final int episodeCount;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.episodeCount,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final episodes = json["episode"] as List? ?? [];
    return Character(
      id: json["id"] as int,
      name: (json["name"] ?? "").toString(),
      status: (json["status"] ?? "Unknown").toString(),
      species: (json["species"] ?? "Unknown").toString(),
      gender: (json["gender"] ?? "Unknown").toString(),
      origin: (json["origin"] is Map ? json["origin"]["name"] : json["origin"] ?? "Unknown").toString(),
      location: (json["location"] is Map ? json["location"]["name"] : json["location"] ?? "Unknown").toString(),
      episodeCount: episodes.length,
      image: (json["image"] ?? "").toString(),
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
