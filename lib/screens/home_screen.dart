import 'package:flutter/material.dart';
import 'add_student_screen.dart';
import 'search_student_screen.dart';
import 'view_students_screen.dart';
import 'backup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام إدارة الطلاب'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              'إضافة طالب',
              Icons.person_add,
              Colors.green,
              const AddStudentScreen(),
            ),
            _buildMenuCard(
              context,
              'البحث والتعديل',
              Icons.search,
              Colors.orange,
              const SearchStudentScreen(),
            ),
            _buildMenuCard(
              context,
              'عرض الطلاب + PDF',
              Icons.list_alt,
              Colors.blue,
              const ViewStudentsScreen(),
            ),
            _buildMenuCard(
              context,
              'النسخ الاحتياطي',
              Icons.backup,
              Colors.purple,
              const BackupScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
