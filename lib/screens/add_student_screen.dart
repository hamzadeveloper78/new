import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _govController = TextEditingController();
  final TextEditingController _distController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _isoController = TextEditingController();
  final TextEditingController _specController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedIdType = 'بطاقة شخصية';
  final List<String> _idTypes = ['بطاقة شخصية', 'جواز سفر', 'بطاقة عائلية', 'أخرى'];

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
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
        createdAt: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      );

      await _dbHelper.insertStudent(student);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ بيانات الطالب بنجاح')),
        );
        _clearFields();
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _idNumberController.clear();
    _govController.clear();
    _distController.clear();
    _villageController.clear();
    _isoController.clear();
    _specController.clear();
    _levelController.clear();
    _phoneController.clear();
    setState(() {
      _selectedIdType = 'بطاقة شخصية';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة طالب جديد')),
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
                DropdownButtonFormField<String>(
                  value: _selectedIdType,
                  decoration: const InputDecoration(
                    labelText: 'نوع الهوية',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  items: _idTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) => setState(() => _selectedIdType = value!),
                ),
                const SizedBox(height: 10),
                _buildTextField(_idNumberController, 'رقم الهوية', Icons.numbers, keyboardType: TextInputType.number),
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
                _buildTextField(_phoneController, 'رقم التلفون', Icons.phone, keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveStudent,
                        icon: const Icon(Icons.save),
                        label: const Text('حفظ الطالب'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _clearFields,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('مسح الحقول'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
    );
  }
}
