import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/student.dart';

class SearchStudentScreen extends StatefulWidget {
  const SearchStudentScreen({super.key});

  @override
  State<SearchStudentScreen> createState() => _SearchStudentScreenState();
}

class _SearchStudentScreenState extends State<SearchStudentScreen> {
  final _dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Student> _searchResults = [];

  void _search() async {
    if (_searchController.text.isNotEmpty) {
      final results = await _dbHelper.searchStudents(_searchController.text);
      setState(() {
        _searchResults = results;
      });
    }
  }

  void _deleteStudent(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الطالب؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm) {
      await _dbHelper.deleteStudent(id);
      _search();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الطالب بنجاح')));
      }
    }
  }

  void _editStudent(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditStudentScreen(student: student)),
    ).then((_) => _search());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البحث عن طالب')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'ابحث بالاسم أو رقم الهوية',
                  suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _search),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _search(),
              ),
            ),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('لا توجد نتائج'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final student = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(student.name),
                            subtitle: Text('رقم الهوية: ${student.idNumber} - التخصص: ${student.specialization}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editStudent(student)),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteStudent(student.id!)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditStudentScreen extends StatefulWidget {
  final Student student;
  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();
  
  late TextEditingController _nameController;
  late TextEditingController _idNumberController;
  late TextEditingController _govController;
  late TextEditingController _distController;
  late TextEditingController _villageController;
  late TextEditingController _isoController;
  late TextEditingController _specController;
  late TextEditingController _levelController;
  late TextEditingController _phoneController;
  late String _selectedIdType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _idNumberController = TextEditingController(text: widget.student.idNumber);
    _govController = TextEditingController(text: widget.student.governorate);
    _distController = TextEditingController(text: widget.student.district);
    _villageController = TextEditingController(text: widget.student.village);
    _isoController = TextEditingController(text: widget.student.isolation);
    _specController = TextEditingController(text: widget.student.specialization);
    _levelController = TextEditingController(text: widget.student.level);
    _phoneController = TextEditingController(text: widget.student.phone);
    _selectedIdType = widget.student.idType;
  }

  void _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      final updatedStudent = Student(
        id: widget.student.id,
        name: _nameController.text,
        idType: _selectedIdType,
        idNumber: _idNumberController.text,
        governorate: _govController.text,
        district: _distController.text,
        village: _villageController.text,
        isolation: _isoController.text,
        specialization: _specController.text,
        level: _levelController.text,
        phone: _phoneController.text,
        createdAt: widget.student.createdAt,
      );

      await _dbHelper.updateStudent(updatedStudent);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث البيانات بنجاح')));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل بيانات الطالب')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_nameController, 'اسم الطالب', Icons.person),
                const SizedBox(height: 10),
                _buildTextField(_idNumberController, 'رقم الهوية', Icons.numbers),
                const SizedBox(height: 10),
                _buildTextField(_govController, 'المحافظة', Icons.location_city),
                const SizedBox(height: 10),
                _buildTextField(_distController, 'المديرية', Icons.map),
                const SizedBox(height: 10),
                _buildTextField(_villageController, 'القرية', Icons.home),
                const SizedBox(height: 10),
                _buildTextField(_isoController, 'العزلة', Icons.location_on),
                const SizedBox(height: 10),
                _buildTextField(_specController, 'التخصص', Icons.school),
                const SizedBox(height: 10),
                _buildTextField(_levelController, 'المستوى', Icons.layers),
                const SizedBox(height: 10),
                _buildTextField(_phoneController, 'رقم التلفون', Icons.phone),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateStudent,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  child: const Text('تحديث البيانات'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
      validator: (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
    );
  }
}
