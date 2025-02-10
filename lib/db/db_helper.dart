import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../data/employee.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'employees.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            role TEXT,
            fromDate TEXT,
            toDate TEXT
          )
        ''');
      },
    );
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return maps.map((e) => Employee.fromMap(e)).toList();
  }

  Future<void> insertEmployee(Employee employee) async {
    final db = await database;
    await db.insert('employees', employee.toMap());
  }

  Future<void> updateEmployee(Employee employee) async {
    final db = await database;
    await db.update('employees', employee.toMap(), where: 'id = ?', whereArgs: [employee.id]);
  }

  Future<void> deleteEmployee(int id) async {
    final db = await database;
    await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}
