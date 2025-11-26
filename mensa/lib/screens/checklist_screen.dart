import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/checklist_status.dart';
import '../services/api_service.dart';

class ChecklistScreen extends StatefulWidget {
  final String userId;
  final int currentWeek;

  const ChecklistScreen({
    super.key,
    required this.userId,
    required this.currentWeek,
  });

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final ApiService _apiService = ApiService();
  Map<String, List<ChecklistStatus>> _checklistByWeek = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/checklist_templates.json',
      );
      final Map<String, dynamic> data = json.decode(response);

      final Map<String, List<ChecklistStatus>> checklist = {};

      data.forEach((weekKey, tasks) {
        final week = int.parse(weekKey.split('_')[1]);
        checklist[weekKey] = (tasks as List).map((task) {
          return ChecklistStatus(
            userId: widget.userId,
            week: week,
            task: task,
            completed: false,
          );
        }).toList();
      });

      setState(() {
        _checklistByWeek = checklist;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading checklist: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleTask(ChecklistStatus status) async {
    final updated = ChecklistStatus(
      userId: status.userId,
      week: status.week,
      task: status.task,
      completed: !status.completed,
    );

    await _apiService.updateChecklistTask(updated);

    setState(() {
      final weekKey = 'week_${status.week}';
      final index = _checklistByWeek[weekKey]!.indexWhere(
        (item) => item.task == status.task,
      );
      if (index != -1) {
        _checklistByWeek[weekKey]![index] = updated;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBE6),
      appBar: AppBar(
        title: const Text('Pregnancy Checklist'),
        backgroundColor: const Color(0xFFF7DC6F),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: _checklistByWeek.entries.map((entry) {
                final weekKey = entry.key;
                final week = int.parse(weekKey.split('_')[1]);
                final tasks = entry.value;
                final isCurrentWeek = week == widget.currentWeek;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: isCurrentWeek ? const Color(0xFFFFF9C4) : null,
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          'Week $week',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isCurrentWeek
                                ? const Color(0xFFF57C00)
                                : null,
                          ),
                        ),
                        if (isCurrentWeek) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF57C00),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Current',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    children: tasks.map((task) {
                      return CheckboxListTile(
                        title: Text(task.task),
                        value: task.completed,
                        onChanged: (value) => _toggleTask(task),
                        activeColor: const Color(0xFF4CAF50),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
