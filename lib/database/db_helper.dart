import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "students.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        idType TEXT NOT NULL,
        idNumber TEXT NOT NULL,
        governorate TEXT NOT NULL,
        district TEXT NOT NULL,
        village TEXT NOT NULL,
        isolation TEXT NOT NULL,
        specialization TEXT NOT NULL,
        level TEXT NOT NULL,
        phone TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {
    Database db = await database;
    return await db.insert('Students', student.toMap());
  }

  Future<List<Student>> getAllStudents() async {
    Database db = await database;
    var result = await db.query('Students', orderBy: 'id DESC');
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<List<Student>> searchStudents(String query) async {
    Database db = await database;
    var result = await db.query(
      'Students',
      where: 'name LIKE ? OR idNumber LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<int> updateStudent(Student student) async {
    Database db = await database;
    return await db.update(
      'Students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    Database db = await database;
    return await db.delete(
      'Students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<String> getDatabasePath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, "students.db");
  }
}
