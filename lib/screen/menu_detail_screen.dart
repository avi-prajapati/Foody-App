import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:http/http.dart' as http;

class MenuDetailScreen extends StatefulWidget {
  final String mealId;

  MenuDetailScreen({required this.mealId});

  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  Map<String, dynamic>? mealDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealDetail();
  }

  Future<void> fetchMealDetail() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        mealDetail = data['meals'][0];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text('Meal Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              if (mealDetail != null) {
                final shareText = '''
              Check out this meal!

              Name: ${mealDetail!['strMeal']}
              Category: ${mealDetail!['strCategory']}
              Area: ${mealDetail!['strArea']}

              Instructions:
              ${mealDetail!['strInstructions']}

              Watch it here: ${mealDetail!['strYoutube']}
              ''';
                Share.share(shareText);
              }
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(mealDetail!['strMealThumb']),
                  const SizedBox(height: 16),
                  Text(
                    mealDetail!['strMeal'],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Category: ${mealDetail!['strCategory']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Area: ${mealDetail!['strArea']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Instructions:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mealDetail!['strInstructions'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
