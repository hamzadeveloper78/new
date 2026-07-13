import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../database/db_helper.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  Future<void> _createBackup(BuildContext context) async {
    try {
      final dbHelper = DatabaseHelper();
      final dbPath = await dbHelper.getDatabasePath();
      final file = File(dbPath);

      if (await file.exists()) {
        final xFile = XFile(dbPath);
        await Share.shareXFiles([xFile], text: 'نسخة احتياطية لقاعدة بيانات الطلاب');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('قاعدة البيانات غير موجودة')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في النسخ الاحتياطي: $e')));
      }
    }
  }

  Future<void> _restoreBackup(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File backupFile = File(result.files.single.path!);
        final dbHelper = DatabaseHelper();
        final dbPath = await dbHelper.getDatabasePath();
        
        // إغلاق قاعدة البيانات الحالية قبل الاستبدال (في التطبيقات الحقيقية يفضل عمل ذلك)
        // هنا سنقوم بنسخ الملف مباشرة
        await backupFile.copy(dbPath);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت استعادة النسخة الاحتياطية بنجاح. يرجى إعادة تشغيل التطبيق.')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في الاستعادة: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('النسخ الاحتياطي والاستعادة')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 30),
              const Text(
                'يمكنك تصدير قاعدة البيانات كملف للنسخ الاحتياطي أو استيراد ملف سابق لاستعادة البيانات.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _createBackup(context),
                icon: const Icon(Icons.share),
                label: const Text('إنشاء نسخة احتياطية ومشاركتها'),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => _restoreBackup(context),
                icon: const Icon(Icons.file_open),
                label: const Text('استعادة نسخة احتياطية من ملف'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
