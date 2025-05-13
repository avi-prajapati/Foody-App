import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview/screen/menu_detail_screen.dart';

class MealSearchingScreen extends StatefulWidget {
  @override
  _MealSearchingScreenState createState() => _MealSearchingScreenState();
}

class _MealSearchingScreenState extends State<MealSearchingScreen> {
  TextEditingController _controller = TextEditingController();
  List meals = [];
  bool isLoading = false;

  Future<void> searchMeals(String query) async {
    setState(() => isLoading = true);

    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        meals = data['meals'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching meals')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Meals')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Text field with search icon
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter meal name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchMeals(_controller.text.trim());
                  },
                ),
              ),
              onSubmitted: searchMeals,
            ),
            SizedBox(height: 16),

            // 📄 Results or Loading
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: meals.isEmpty
                        ? Text('No results')
                        : ListView.builder(
                            itemCount: meals.length,
                            itemBuilder: (context, index) {
                              final meal = meals[index];
                              return ListTile(
                                leading: Image.network(
                                  meal['strMealThumb'],
                                  width: 50,
                                ),
                                title: Text(meal['strMeal']),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuDetailScreen(
                                          mealId: meal['idMeal']),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
