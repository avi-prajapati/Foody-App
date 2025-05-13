import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview/helper/meal_searching_screen.dart';

import '../model/category_model.dart';
import 'category_allmenu_screen.dart';

class FoodCategoryDesign extends StatefulWidget {
  @override
  _FoodCategoryDesignState createState() => _FoodCategoryDesignState();
}

class _FoodCategoryDesignState extends State<FoodCategoryDesign> {
  bool _isSearching = false;
  List _searchResults = [];
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List categoryList = data['categories'];

      setState(() {
        categories =
            categoryList.map((json) => Category.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  //Function for searching the meal.
  Future<void> searchMeals(String query) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _searchResults = data['meals'] ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text(
          'F🍩🍩dy',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealSearchingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFF49A5EF),
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.only(
                        right: 10, left: 10, top: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                  category: category.strCategory),
                            ));
                      },
                      child: Column(
                        children: [
                          Image.network(category.strCategoryThumb,
                              width: 100, height: 100),
                          Text(
                            category.strCategory,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
    );
  }
}
