class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
    );
  }
}
