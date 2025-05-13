import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview/screen/menu_detail_screen.dart';

import 'food_category_design.dart';

class FoodCategoryScreen extends StatefulWidget {
  const FoodCategoryScreen({super.key});

  @override
  State<FoodCategoryScreen> createState() => _FoodCategoryScreenState();
}

class _FoodCategoryScreenState extends State<FoodCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //foating Button.
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(
          Icons.fastfood_outlined,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        tooltip: 'Random Meal',
        onPressed: () async {
          final response = await http.get(
              Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final randomMeal = data['meals'][0];
            final randomMealId = randomMeal['idMeal'];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuDetailScreen(mealId: randomMealId),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load random meal')),
            );
          }
        },
      ),

      //Body
      body: FoodCategoryDesign(),
    );
  }
}
