import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fintrack/models/transaction.dart' as model;
import 'package:fintrack/models/budget.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fintrack.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory;
    if (kIsWeb) {
      // Handle web platform
      throw UnsupportedError(
          'Web platform is not supported for local database.');
    } else if (Platform.isMacOS) {
      documentsDirectory = await getApplicationSupportDirectory();
    } else {
      documentsDirectory = await getApplicationDocumentsDirectory();
    }
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        title TEXT,
        amount REAL,
        date TEXT,
        category TEXT,
        account TEXT,
        type TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE budgets(
        category TEXT PRIMARY KEY,
        budget_limit REAL
      )
    ''');
  }

  Future<void> insertTransaction(model.Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<model.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(
        maps.length, (i) => model.Transaction.fromMap(maps[i]));
  }

  Future<void> insertBudget(Budget budget) async {
    final db = await database;
    await db.insert('budgets', budget.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateBudget(Budget budget) async {
    final db = await database;
    await db.update('budgets', budget.toMap(),
        where: 'category = ?', whereArgs: [budget.category]);
  }

  Future<List<Budget>> getBudgets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budgets');
    return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
  }
}
