class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
    );
  }
}