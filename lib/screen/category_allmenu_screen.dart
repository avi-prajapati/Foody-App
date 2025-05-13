import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/meal_model.dart';
import 'menu_detail_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String category;

  CategoryDetailScreen({required this.category});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<Meal> meals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealsByCategory();
  }

  Future<void> fetchMealsByCategory() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List mealsList = data['meals'];

      setState(() {
        meals = mealsList.map((json) => Meal.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load meals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text(
          'F🍩🍩dy',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(right: 8, left: 8, top: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xFF49A5EF),
                      borderRadius: BorderRadius.circular(15)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MenuDetailScreen(mealId: meal.idMeal),
                          ));
                    },
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(meal.strMealThumb,
                                width: 70, height: 70)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              meal.strMeal,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
