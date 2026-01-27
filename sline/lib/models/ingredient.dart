class Ingredient {
  final String name;
  final String? function;
  final String? safety;
  final String? irritation;
  final String? comedogenic;

  Ingredient({
    required this.name,
    this.function,
    this.safety,
    this.irritation,
    this.comedogenic,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      function: json['function'] as String?,
      safety: json['safety'] as String?,
      irritation: json['irritation'] as String?,
      comedogenic: json['comedogenic'] as String?,
    );
  }
} 