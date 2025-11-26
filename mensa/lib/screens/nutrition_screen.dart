import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_pregnancy.dart';
import '../models/food_item.dart';

class NutritionScreen extends StatefulWidget {
  final String userId;
  final UserPregnancy profile;

  const NutritionScreen({
    super.key,
    required this.userId,
    required this.profile,
  });

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  List<FoodItem> _foods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/foods.json',
      );
      final List<dynamic> data = json.decode(response);
      setState(() {
        _foods = data.map((json) => FoodItem.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading foods: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trimester = widget.profile.trimester;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF4),
      appBar: AppBar(
        title: const Text('Nutrition Guide'),
        backgroundColor: const Color(0xFF98D8C8),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: const Color(0xFFE8F8F5),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trimester $trimester Nutrition',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getTrimesterAdvice(trimester),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (widget.profile.allergies.isNotEmpty) ...[
                    Card(
                      color: const Color(0xFFFFF3CD),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber,
                              color: Color(0xFFFF9800),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your allergies: ${widget.profile.allergies.join(", ")}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const Text(
                    'Recommended Foods',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _foods.length,
                    itemBuilder: (context, index) {
                      final food = _foods[index];
                      final isSafe = food.isSafeFor(widget.profile.allergies);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isSafe
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF5252),
                            child: Icon(
                              isSafe ? Icons.check : Icons.warning,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            food.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Nutrients: ${food.nutrients.join(", ")}'),
                              if (!isSafe) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '⚠ Contains: ${food.avoidIfAllergic.join(", ")}',
                                  style: const TextStyle(
                                    color: Color(0xFFD32F2F),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Icon(
                            isSafe ? Icons.thumb_up : Icons.block,
                            color: isSafe
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF5252),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  String _getTrimesterAdvice(int trimester) {
    switch (trimester) {
      case 1:
        return 'Focus on folic acid, iron, and protein. Eat small frequent meals to manage nausea.';
      case 2:
        return 'Increase calcium and vitamin D intake. Your baby\'s bones are developing rapidly.';
      case 3:
        return 'Boost iron and protein. Stay hydrated and eat fiber-rich foods to prevent constipation.';
      default:
        return 'Maintain a balanced diet with plenty of nutrients.';
    }
  }
}
