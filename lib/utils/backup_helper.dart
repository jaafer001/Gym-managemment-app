import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../database/database_helper.dart';
import '../models/member.dart';

class BackupHelper {
  static Future<String?> exportData() async {
    try {
      final members = await DatabaseHelper.instance.getMembers();
      final data = jsonEncode(members.map((m) => m.toJson()).toList());
      
      // Use application documents directory instead of deprecated getExternalStorageDirectory
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/gym_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(data);
      return file.path; // Return file path for user reference
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  static Future<void> importData(String? filePath) async {
    try {
      File file;
      if (filePath != null && filePath.isNotEmpty) {
        file = File(filePath);
      } else {
        // Fallback to default backup location
        final dir = await getApplicationDocumentsDirectory();
        // Try to find the most recent backup
        final directory = dir;
        final files = directory.listSync()
            .whereType<File>()
            .where((f) => f.path.contains('gym_backup') && f.path.endsWith('.json'))
            .toList();
        if (files.isEmpty) {
          throw Exception('No backup file found');
        }
        // Sort by modification time and get most recent
        files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
        file = files.first;
      }

      if (!await file.exists()) {
        throw Exception('Backup file not found');
      }

      final data = jsonDecode(await file.readAsString()) as List;
      for (var json in data) {
        try {
          final member = Member.fromJson(json);
          await DatabaseHelper.instance.insertMember(member);
        } catch (e) {
          // Log error but continue with other members
          print('خطأ في استيراد عضو: $e');
        }
      }
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }
}
