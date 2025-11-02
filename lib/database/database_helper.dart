import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/member.dart';
// ignore: unused_import
import '../models/Subscription.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gym_membership.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        photoPath TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        memberId INTEGER NOT NULL,
        type TEXT NOT NULL,
        duration INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        isActive INTEGER NOT NULL,
        FOREIGN KEY (memberId) REFERENCES members (id)
      )
    ''');
  }

  Future<int> insertMember(Member member) async {
    final db = await instance.database;
    final id = await db.insert('members', {
      'name': member.name,
      'age': member.age,
      'gender': member.gender,
      'phone': member.phone,
      'email': member.email,
      'photoPath': member.photoPath,
    });
    for (var sub in member.subscriptions) {
      await db.insert('subscriptions', {
        'memberId': id,
        'type': sub.type,
        'duration': sub.duration,
        'startDate': sub.startDate.toIso8601String(),
        'endDate': sub.endDate.toIso8601String(),
        'isActive': sub.isActive ? 1 : 0,
      });
    }
    return id;
  }

  Future<List<Member>> getMembers() async {
    final db = await instance.database;
    final memberMaps = await db.query('members');
    final now = DateTime.now();
    List<Member> members = [];
    for (var map in memberMaps) {
      final subs = await db.query('subscriptions', where: 'memberId = ?', whereArgs: [map['id']]);
      final updatedSubs = <Map<String, dynamic>>[];
      for (var s in subs) {
        final endDate = DateTime.parse(s['endDate'] as String);
        final isActive = endDate.isAfter(now);
        // Update subscription active status in database if it changed
        if ((s['isActive'] as int == 1) != isActive) {
          await db.update('subscriptions', {'isActive': isActive ? 1 : 0}, 
              where: 'id = ?', whereArgs: [s['id']]);
        }
        updatedSubs.add({
          'id': s['id'],
          'type': s['type'],
          'duration': s['duration'],
          'startDate': s['startDate'],
          'endDate': s['endDate'],
          'isActive': isActive,
        });
      }
      members.add(Member.fromJson({
        ...map,
        'subscriptions': updatedSubs,
      }));
    }
    return members;
  }

  Future<void> updateMember(Member member) async {
    final db = await instance.database;
    await db.update('members', {
      'name': member.name,
      'age': member.age,
      'gender': member.gender,
      'phone': member.phone,
      'email': member.email,
      'photoPath': member.photoPath,
    }, where: 'id = ?', whereArgs: [member.id]);
    
    // Delete existing subscriptions for this member
    await db.delete('subscriptions', where: 'memberId = ?', whereArgs: [member.id]);
    
    // Insert updated subscriptions
    for (var sub in member.subscriptions) {
      await db.insert('subscriptions', {
        'memberId': member.id,
        'type': sub.type,
        'duration': sub.duration,
        'startDate': sub.startDate.toIso8601String(),
        'endDate': sub.endDate.toIso8601String(),
        'isActive': sub.isActive ? 1 : 0,
      });
    }
  }

  Future<void> deleteMember(int id) async {
    final db = await instance.database;
    await db.delete('subscriptions', where: 'memberId = ?', whereArgs: [id]);
    await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  // Add methods for stats, search, etc.
}