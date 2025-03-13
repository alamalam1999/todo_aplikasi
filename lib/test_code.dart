import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Task {
  final int id;
  final String title;

  Task({required this.id, required this.title});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [
    Task(id: 1, title: 'Buy groceries'),
    Task(id: 2, title: 'Complete project'),
    Task(id: 3, title: 'Call mom'),
  ];

  Set<int> selectedTaskIds = {};

  Future<Database> openMyDatabase() async {
    return openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE todoList (id INTEGER PRIMARY KEY, title TEXT)',
        );
      },
    );
  }

  Future<void> deleteAllSelectedTasks() async {
    final db = await openMyDatabase();
    final idPlaceholders = selectedTaskIds.map((_) => '?').join(',');
    await db.delete(
      'todoList',
      where: 'id IN ($idPlaceholders)',
      whereArgs: selectedTaskIds.toList(),
    );

    setState(() {
      tasks.removeWhere((task) => selectedTaskIds.contains(task.id));
      selectedTaskIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          if (selectedTaskIds.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteAllSelectedTasks,
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final isSelected = selectedTaskIds.contains(task.id);

          return ListTile(
            title: Text(task.title),
            leading: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedTaskIds.add(task.id);
                  } else {
                    selectedTaskIds.remove(task.id);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}
