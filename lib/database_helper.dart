import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'expense_tracker.db';

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

Future<Database> _initDatabase() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, dbName);
  return await openDatabase(
    path, 
    version: 2, // Incremented version number
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
  );
}

Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Add the new column if it doesn't exist
    await db.execute('''
      ALTER TABLE expenses ADD COLUMN tag TEXT;
    ''');
  }
}

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        phoneNumber TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY,
        phoneNumber TEXT,
        name TEXT,
        expenseVia TEXT,
        tag TEXT,
        remarks TEXT,
        amount REAL,
        date TEXT,
        FOREIGN KEY (phoneNumber) REFERENCES users(phoneNumber)
      )
    ''');

    await db.execute('''
      CREATE TABLE tags(
        id INTEGER PRIMARY KEY,
        name TEXT UNIQUE
      )
    ''');
  }

  // User CRUD operations

  Future<int> createUser(String phoneNumber) async {
    try {
      final db = await database;
      return await db.insert('users', {'phoneNumber': phoneNumber});
    } catch (e) {
      print('Error creating user: $e');
      return -1; 
    }
  }

  Future<Map<String, dynamic>?> getUserByPhoneNumber(String phoneNumber) async {
    try {
      final db = await database;
      var res = await db.query('users', where: 'phoneNumber = ?', whereArgs: [phoneNumber]);
      return res.isNotEmpty ? res.first : null;
    } catch (e) {
      print('Error getting user by phoneNumber: $e');
      return null; 
    }
  }

  // Expense CRUD operations

  Future<int> addExpense(Expense expense) async {
    try {
      final db = await database;
      print(db);
      return await db.insert('expenses', expense.toMap());
    } catch (e) {
      print('Error adding expense: $e');
      return -1;
    }
  }

  Future<int> updateExpense(Expense expense) async {
    try {
      final db = await database;
      return await db.update('expenses', expense.toMap(),
          where: 'id = ?', whereArgs: [expense.id]);
    } catch (e) {
      print('Error updating expense: $e');
      return -1; 
    }
  }

  Future<int> deleteExpense(int id) async {
    try {
      final db = await database;
      return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting expense: $e');
      return -1;
    }
  }

  Future<List<Expense>> getAllExpensesByPhoneNumber(String phoneNumber) async {
    try {
      final db = await database;
      var res = await db.query('expenses', where: 'phoneNumber = ?', whereArgs: [phoneNumber]);
      print(res);
      return res.isNotEmpty ? res.map((e) => Expense.fromMap(e)).toList() : [];
    } catch (e) {
      print('Error getting expenses by phoneNumber: $e');
      return []; // or throw e; depending on your error handling strategy
    }
  }

  Future<List<Expense>> getExpensesByDateRange(String phoneNumber, String fromDate, String toDate) async {
    try {
      final db = await database;
      var res = await db.query('expenses',
          where: 'phoneNumber = ? AND date BETWEEN ? AND ?',
          whereArgs: [phoneNumber, fromDate, toDate]);
      return res.isNotEmpty ? res.map((e) => Expense.fromMap(e)).toList() : [];
    } catch (e) {
      print('Error getting expenses by date range: $e');
      return []; // or throw e; depending on your error handling strategy
    }
  }

  // Tag operations

  Future<int> addTag(String tagName) async {
    try {
      final db = await database;
      return await db.insert('tags', {'name': tagName});
    } catch (e) {
      print('Error adding tag: $e');
      return -1; // or throw e; depending on your error handling strategy
    }
  }

  Future<int> updateTag(int id, String newTagName) async {
    try {
      final db = await database;
      return await db.update('tags', {'name': newTagName}, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error updating tag: $e');
      return -1; // or throw e; depending on your error handling strategy
    }
  }

  Future<int> deleteTag(int id) async {
    try {
      final db = await database;
      return await db.delete('tags', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting tag: $e');
      return -1; // or throw e; depending on your error handling strategy
    }
  }

  Future<List<Map<String, dynamic>>> getAllTags() async {
    try {
      final db = await database;
      var res = await db.query('tags');
      return res.isNotEmpty ? res : [];
    } catch (e) {
      print('Error getting all tags: $e');
      return []; // or throw e; depending on your error handling strategy
    }
  }


 


}


// Expense class
class Expense {
   int? id;
   String? phoneNumber;
   String? name;
   String? expenseVia;
   String? tag;
   String? remarks;
   double? amount;
   String? date;

  Expense({
    this.id,
     this.phoneNumber,
     this.name,
     this.expenseVia,
     this.tag,
     this.remarks,
     this.amount,
     this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      phoneNumber: map['phoneNumber'],
      name: map['name'],
      expenseVia: map['expenseVia'],
      tag: map['tag'],
      remarks: map['remarks'],
      amount: map['amount'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'expenseVia': expenseVia,
      'tag':tag,
      'remarks':remarks,
      'amount':amount,
      'date':date
    };
  }
}